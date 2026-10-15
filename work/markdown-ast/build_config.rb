require "yaml"
require "commonmarker"
require_relative "dtd"
require_relative "spec_corpus"

module BuildConfig
  DTD_PATH = "refs/commonmark-spec/CommonMark.dtd".freeze

  CORPORA = {
    "commonmark" => "refs/commonmark-spec/spec.txt",
    "gfm" => "refs/cmark-gfm/test/spec.txt",
  }.freeze

  SPECIMEN = File.expand_path("kitchen-sink.md", __dir__)
  CONFIG = File.expand_path("config.yml", __dir__)

  OPTIONS = {
    extension: Commonmarker::Config::OPTIONS[:extension]
      .to_h { |name, value| [name, [true, false].include?(value) ? true : value] }
      .merge(front_matter_delimiter: "---"),
  }.freeze

  PROPERTY_METHODS = (Commonmarker::Node.instance_methods - Object.instance_methods - Enumerable.instance_methods)
    .reject { |name| name.to_s.end_with?("=") }
    .sort
    .freeze

  SKIPPED = %i[source_position string_content].freeze

  ATTRIBUTE_NAMES = {
    "heading" => { "level" => "header_level" },
    "code_block" => { "info" => "fence_info" },
    "link" => { "destination" => "url", "title" => "title" },
    "image" => { "destination" => "url", "title" => "title" },
    "list" => { "type" => "list_type", "start" => "list_start", "tight" => "list_tight" },
  }.freeze

  module_function

  def documents
    CORPORA.filter_map { |_, path| SpecCorpus.examples(path) if File.exist?(path) }
           .flatten
           .push(File.read(SPECIMEN))
  end

  def observe
    observed = {}

    documents.each do |markdown|
      Commonmarker.parse(markdown, options: OPTIONS).walk do |node|
        record = observed[node.type] ||= { properties: {}, children: [] }
        supported = PROPERTY_METHODS.select { |method| node.node_supports?(method) == true }

        (supported - SKIPPED).each do |property|
          (record[:properties][property] ||= []) << node.public_send(property)
        end

        child = node.first_child
        while child
          record[:children] << child.type
          child = child.next_sibling
        end
      end
    end

    observed
  end

  def class_name_for(type)
    type.to_s.split("_").map(&:capitalize).join
  end

  def field_type_for(values)
    classes = values.map(&:class).uniq

    return "boolean" if classes.all? { |klass| [TrueClass, FalseClass].include?(klass) }
    return "enum" if classes == [Symbol]
    return "integer" if classes == [Integer]
    return "string" unless classes.include?(NilClass)

    "string?"
  end

  def dtd_attribute(dtd, type, property)
    element = dtd[:elements][type.to_s]
    return nil unless element

    mapping = ATTRIBUTE_NAMES.fetch(type.to_s, {})
    spec_name = mapping.key(property.to_s) || property.to_s

    (element[:attributes] || []).find { |attribute| attribute[:name] == spec_name }
  end

  def fields_for(type, record, dtd)
    record[:properties].sort.map do |property, values|
      attribute = dtd_attribute(dtd, type, property)
      symbols = values.map(&:class).uniq == [Symbol]

      {
        "name" => property.to_s,
        "type" => field_type_for(values),
        "required" => attribute ? attribute[:required] : false,
        "domain" => attribute&.dig(:domain) || (symbols ? values.uniq.map(&:to_s).sort : nil),
        "spec" => attribute&.dig(:name),
      }.compact
    end
  end

  def unavailable_for(type, record, dtd)
    element = dtd[:elements][type.to_s]
    return [] unless element

    mapping = ATTRIBUTE_NAMES.fetch(type.to_s, {})
    exposed = record[:properties].keys.map { |property| mapping.key(property.to_s) || property.to_s }

    (element[:attributes] || []).reject { |attribute| exposed.include?(attribute[:name]) }.map do |attribute|
      { "name" => attribute[:name], "domain" => attribute[:domain] }.compact
    end
  end

  def node_entry(type, record, dtd)
    element = dtd[:elements][type.to_s]
    specified = element && element[:children] != :text

    {
      "name" => class_name_for(type),
      "type" => type.to_s,
      "source" => element ? "dtd" : "parser",
      "fields" => fields_for(type, record, dtd),
      "children" => record[:children].uniq.sort.map { |child| class_name_for(child) },
      "spec_children" => specified ? element[:children].sort.map { |child| class_name_for(child) } : nil,
      "unavailable" => unavailable_for(type, record, dtd),
    }.reject { |_, value| value.nil? || value == [] }
  end

  def build
    dtd = Dtd.parse(DTD_PATH)
    observed = observe

    {
      "generated_from" => { "dtd" => DTD_PATH, "corpora" => CORPORA.values, "specimen" => "kitchen-sink.md" },
      "property_methods" => PROPERTY_METHODS.map(&:to_s),
      "specified_but_not_emitted" => dtd[:elements].keys.reject { |name| observed.key?(name.to_sym) },
      "nodes" => observed.sort_by { |type, _| type.to_s }.map { |type, record| node_entry(type, record, dtd) },
    }
  end

  def write!
    build.tap { |config| File.write(CONFIG, config.to_yaml) }
  end
end

if __FILE__ == $PROGRAM_NAME
  config = BuildConfig.write!
  nodes = config.fetch("nodes")
  from_dtd = nodes.count { |node| node.fetch("source") == "dtd" }

  puts "wrote work/markdown-ast/config.yml"
  puts "  nodes: #{nodes.size} (#{from_dtd} from the dtd, #{nodes.size - from_dtd} from the parser)"
  puts "  specified but not emitted: #{config.fetch("specified_but_not_emitted").inspect}"

  nodes.each do |node|
    unreachable = node["unavailable"]
    next unless unreachable

    label = node.fetch("name")
    names = unreachable.map { |attribute| attribute.fetch("name") }
    puts "  #{label}: specified but unreachable: #{names.inspect}"
  end
end
