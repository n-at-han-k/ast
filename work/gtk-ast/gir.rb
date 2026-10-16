require "set"
require "rexml/parsers/streamparser"
require "rexml/streamlistener"

module Gir
  GIR_DIR = File.expand_path("gir", __dir__)

  class Listener
    include REXML::StreamListener

    attr_reader :namespace, :classes, :interfaces, :enums, :records

    def initialize
      @classes = {}
      @interfaces = {}
      @enums = {}
      @records = {}
      @current = nil
      @current_property = nil
      @current_enum = nil
    end

    def tag_start(name, attributes)
      case name
      when "namespace" then @namespace = attributes["name"]
      when "class" then start_type(@classes, attributes)
      when "interface" then start_type(@interfaces, attributes)
      when "record" then start_record(attributes)
      when "enumeration" then start_enum(attributes, "enum")
      when "bitfield" then start_enum(attributes, "flags")
      when "member" then @current_enum&.fetch("members")&.push(attributes["name"])
      when "implements" then @current&.fetch("implements")&.push(qualified(attributes["name"]))
      when "property" then start_property(attributes)
      when "glib:signal" then @current&.fetch("signals")&.push(attributes["name"])
      when "array" then @current_property&.store("container", attributes["name"] || "array")
      when "type" then record_type(attributes)
      end
    end

    def tag_end(name)
      case name
      when "class", "interface" then @current = nil
      when "enumeration", "bitfield" then @current_enum = nil
      when "property" then @current_property = nil
      end
    end

    private

    def record_type(attributes)
      return if @current_property.nil? || @current_property.key?("gir_type")

      @current_property["gir_type"] = qualified(attributes["name"])
    end

    def start_record(attributes)
      name = attributes["name"]
      return if name.nil?

      @records["#{@namespace}.#{name}"] = {
        "name" => "#{@namespace}.#{name}",
        "namespace" => @namespace,
        "gtype" => attributes["glib:type-name"],
      }
    end

    def qualified(name)
      return nil if name.nil?

      name.include?(".") ? name : "#{@namespace}\u0000#{name}"
    end

    def start_type(into, attributes)
      @current = {
        "name" => "#{@namespace}.#{attributes["name"]}",
        "namespace" => @namespace,
        "gtype" => attributes["glib:type-name"],
        "parent" => qualified(attributes["parent"]),
        "implements" => [],
        "properties" => {},
        "signals" => [],
        "abstract" => attributes["abstract"] == "1",
      }
      into[@current.fetch("name")] = @current
    end

    def start_enum(attributes, kind)
      @current_enum = {
        "name" => "#{@namespace}.#{attributes["name"]}",
        "namespace" => @namespace,
        "gtype" => attributes["glib:type-name"],
        "kind" => kind,
        "members" => [],
      }
      @enums[@current_enum.fetch("name")] = @current_enum
    end

    def start_property(attributes)
      return if @current.nil?

      @current_property = {
        "writable" => attributes["writable"] == "1",
        "readable" => attributes["readable"] != "0",
        "construct_only" => attributes["construct-only"] == "1",
        "since" => attributes["version"],
      }
      @current.fetch("properties")[attributes["name"]] = @current_property
    end
  end

  module_function

  def files
    Dir.glob(File.join(GIR_DIR, "*.gir")).sort
  end

  SEPARATOR = "\u0000".freeze

  def parse
    schema = { "classes" => {}, "interfaces" => {}, "enums" => {}, "records" => {}, "namespaces" => [] }

    files.each do |path|
      listener = Listener.new
      REXML::Parsers::StreamParser.new(File.read(path), listener).parse

      schema["namespaces"] << listener.namespace
      schema["classes"].merge!(listener.classes)
      schema["interfaces"].merge!(listener.interfaces)
      schema["enums"].merge!(listener.enums)
      schema["records"].merge!(listener.records)
    end

    schema["namespaces"] = schema["namespaces"].compact.sort
    resolve!(schema)
  end

  def declared(schema)
    @declared ||= %w[classes interfaces enums records].flat_map { |group| schema.fetch(group).keys }.to_set
  end

  def resolve(reference, schema)
    return reference unless reference.is_a?(String) && reference.include?(SEPARATOR)

    namespace, name = reference.split(SEPARATOR, 2)
    qualified = "#{namespace}.#{name}"

    declared(schema).include?(qualified) ? qualified : name
  end

  def resolve!(schema)
    %w[classes interfaces].each do |group|
      schema.fetch(group).each_value do |entry|
        entry["parent"] = resolve(entry["parent"], schema)
        entry["implements"] = entry.fetch("implements").map { |name| resolve(name, schema) }
        entry.fetch("properties").each_value do |meta|
          meta["gir_type"] = resolve(meta["gir_type"], schema)
        end
      end
    end

    schema
  end

  def ancestry(schema, name)
    [].tap do |chain|
      current = name

      while current
        entry = schema["classes"][current] || schema["interfaces"][current]
        break unless entry

        chain << entry
        chain.concat(entry.fetch("implements").filter_map { |iface| schema["interfaces"][iface] })
        current = entry["parent"]
      end
    end
  end

  def properties_for(schema, name)
    {}.tap do |found|
      ancestry(schema, name).reverse_each do |entry|
        entry.fetch("properties").each do |property, meta|
          found[property] = meta.merge("owner" => entry.fetch("name"))
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  abort "run extract_gir.rb --write first" if Gir.files.empty?

  started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  schema = Gir.parse
  elapsed = format("%.1f", Process.clock_gettime(Process::CLOCK_MONOTONIC) - started)

  puts "parsed #{Gir.files.size} gir files in #{elapsed}s"
  puts "  namespaces: #{schema.fetch("namespaces").join(", ")}"
  puts "  classes:    #{schema.fetch("classes").size}"
  puts "  interfaces: #{schema.fetch("interfaces").size}"
  puts "  enums:      #{schema.fetch("enums").size}"

  %w[Gtk.Box Gtk.Button Adw.ApplicationWindow].each do |name|
    entry = schema.dig("classes", name)
    own = entry.fetch("properties")
    all = Gir.properties_for(schema, name)
    chain = Gir.ancestry(schema, name).map { |type| type.fetch("name") }

    puts
    puts "#{name} (gtype #{entry["gtype"]})"
    puts "  parent:     #{entry["parent"]}"
    puts "  own:        #{own.size} properties, inherited total #{all.size}"
    puts "  ancestry:   #{chain.first(6).join(" <- ")}"
    own.each { |property, meta| puts format("    %-20s %s", property, meta["gir_type"]) }
  end
end
