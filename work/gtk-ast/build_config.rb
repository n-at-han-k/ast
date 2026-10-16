require "yaml"
require_relative "grammar"

module BuildConfig
  CONFIG = File.expand_path("config.yml", __dir__)

  module_function

  def class_name_for(name)
    name.split(/[._-]/).map { |part| part[0].upcase + part[1..].to_s }.join
  end

  def reader_for(attribute)
    attribute.sub(/\A[a-z]+:/, "").tr("-", "_")
  end

  def field_for(attribute)
    {
      "name" => reader_for(attribute.fetch("name")),
      "attribute" => attribute.fetch("name"),
      "type" => attribute["type"] || "text",
      "domain" => attribute["domain"],
      "required" => attribute.fetch("required"),
    }.compact
  end

  def node_for(rule, groups)
    inherited = rule.fetch("groups").flat_map { |group| groups.fetch(group, {}).fetch("attributes", []) }

    {
      "name" => class_name_for(rule.fetch("name")),
      "definition" => rule.fetch("name"),
      "element" => rule.fetch("element"),
      "fields" => (rule.fetch("attributes") + inherited).map { |attribute| field_for(attribute) },
      "children" => rule.fetch("children").map do |child|
        { "name" => class_name_for(child.fetch("ref")), "definition" => child.fetch("ref"), "quantifier" => child.fetch("quantifier") }
      end,
      "groups" => rule.fetch("groups"),
    }.reject { |_, value| value.nil? || value == [] }
  end

  def build
    rules = Grammar.rules
    groups = rules.reject { |_, rule| rule["element"] }
    nodes = rules.select { |_, rule| rule["element"] }

    {
      "generated_from" => {
        "grammar" => Grammar::RNC.sub("#{Dir.pwd}/", ""),
        "converted" => Grammar::RNG.sub("#{Dir.pwd}/", ""),
      },
      "groups" => groups.values.map do |group|
        {
          "name" => group.fetch("name"),
          "attributes" => group.fetch("attributes").map { |attribute| field_for(attribute) },
          "children" => group.fetch("children").map { |child| class_name_for(child.fetch("ref")) },
        }.reject { |_, value| value.nil? || value == [] }
      end,
      "nodes" => nodes.values.map { |rule| node_for(rule, groups) },
    }
  end

  def write!
    build.tap { |config| File.write(CONFIG, config.to_yaml) }
  end
end

if __FILE__ == $PROGRAM_NAME
  config = BuildConfig.write!
  nodes = config.fetch("nodes")
  fields = nodes.sum { |node| node.fetch("fields", []).size }
  children = nodes.sum { |node| node.fetch("children", []).size }
  size = format("%.1f", File.size(BuildConfig::CONFIG) / 1024.0)

  puts "wrote work/gtk-ast/config.yml at #{size}K"
  puts "  nodes:    #{nodes.size}"
  puts "  groups:   #{config.fetch("groups").size}"
  puts "  fields:   #{fields}"
  puts "  children: #{children} declared child relations"
  puts

  puts "nodes with the most children:"
  nodes.sort_by { |node| -node.fetch("children", []).size }.first(5).each do |node|
    name = node.fetch("name")
    count = node.fetch("children", []).size
    puts format("  %-16s %2d  %s", name, count, node.fetch("children").map { |child| child.fetch("name") }.first(6).join(", "))
  end
end
