require "yaml"
require_relative "gir"

module BuildConfig
  CONFIG = File.expand_path("config.yml", __dir__)

  module_function

  def field_type_for(gir_type, schema)
    return "unknown" if gir_type.nil?

    enum = schema.dig("enums", gir_type)
    return enum.fetch("kind") if enum

    return "node" if schema.dig("classes", gir_type)
    return "interface" if schema.dig("interfaces", gir_type)
    return "record" if schema.dig("records", gir_type)

    gir_type
  end

  def fields_for(entry, schema)
    entry.fetch("properties").sort.map do |name, meta|
      gir_type = meta["gir_type"]
      type = field_type_for(gir_type, schema)

      {
        "name" => name,
        "type" => type,
        "gir_type" => type == gir_type ? nil : gir_type,
        "container" => meta["container"],
        "writable" => meta.fetch("writable"),
        "readable" => meta.fetch("readable"),
        "construct_only" => meta.fetch("construct_only"),
        "domain" => %w[enum flags].include?(type) ? schema.dig("enums", gir_type, "members")&.dup : nil,
        "since" => meta["since"],
      }.compact
    end
  end

  def entry_for(entry, schema, kind)
    {
      "name" => entry.fetch("name"),
      "kind" => kind,
      "namespace" => entry.fetch("namespace"),
      "gtype" => entry["gtype"],
      "parent" => entry["parent"],
      "implements" => entry.fetch("implements").sort,
      "abstract" => entry.fetch("abstract", false),
      "fields" => fields_for(entry, schema),
      "signals" => entry.fetch("signals").sort,
    }.reject { |_, value| value.nil? || value == [] || value == false }
  end

  def build
    schema = Gir.parse

    nodes = schema.fetch("classes").values.sort_by { |entry| entry.fetch("name") }
                  .map { |entry| entry_for(entry, schema, "class") }
    ifaces = schema.fetch("interfaces").values.sort_by { |entry| entry.fetch("name") }
                   .map { |entry| entry_for(entry, schema, "interface") }

    {
      "generated_from" => {
        "gir" => Gir.files.map { |path| File.basename(path) },
        "namespaces" => schema.fetch("namespaces"),
      },
      "enums" => schema.fetch("enums").values.sort_by { |entry| entry.fetch("name") }.map do |entry|
        entry.slice("name", "namespace", "gtype", "kind", "members")
      end,
      "nodes" => ifaces + nodes,
    }
  end

  def write!
    build.tap { |config| File.write(CONFIG, config.to_yaml) }
  end
end

if __FILE__ == $PROGRAM_NAME
  config = BuildConfig.write!
  nodes = config.fetch("nodes")
  classes = nodes.count { |node| node.fetch("kind") == "class" }
  fields = nodes.sum { |node| node.fetch("fields", []).size }
  size = format("%.1f", File.size(BuildConfig::CONFIG) / 1_048_576.0)

  puts "wrote work/gtk-ast/config.yml at #{size}M"
  puts "  namespaces: #{config.dig("generated_from", "namespaces").size}"
  puts "  nodes:      #{nodes.size} (#{classes} classes, #{nodes.size - classes} interfaces)"
  puts "  enums:      #{config.fetch("enums").size}"
  puts "  fields:     #{fields} declared on their owning type"

  by_type = nodes.flat_map { |node| node.fetch("fields", []) }.group_by { |field| field.fetch("type") }
  puts "  field types:"
  by_type.sort_by { |_, found| -found.size }.each do |type, found|
    puts format("    %-10s %5d", type, found.size)
  end
end
