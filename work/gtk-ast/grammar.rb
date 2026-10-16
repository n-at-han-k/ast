require "set"
require "fileutils"
require "English"
require "nokogiri"

module Grammar
  RNC = File.expand_path("../../refs/gobject-introspection/docs/gir-1.2.rnc", __dir__)
  RNG = File.expand_path("grammar/gir-1.2.rng", __dir__)

  module_function

  def convert!
    FileUtils.mkdir_p(File.dirname(RNG))
    converted = IO.popen(["rnc2rng", RNC], &:read)
    raise "rnc2rng failed" unless $CHILD_STATUS.success? && converted.start_with?("<?xml")

    File.write(RNG, converted)
    RNG
  end

  def document
    convert! unless File.exist?(RNG)
    Nokogiri::XML(File.read(RNG))
  end

  def prefixes(doc)
    doc.root.namespace_definitions.to_h { |definition| [definition.href, definition.prefix] }
  end

  def definitions(doc)
    doc.root.xpath("./xmlns:define").to_h { |define| [define["name"], define] }
  end

  def qualified_name(elements, prefix_map)
    case elements
    in [*, { name: "name", content:, attributes: attrs }, *]
      namespace = attrs.find { |attribute| attribute.name == "ns" }&.value.to_s
      prefix = prefix_map[namespace]
      prefix.to_s.empty? || namespace.empty? ? content : "#{prefix}:#{content}"
    else
      nil
    end
  end

  def datatype_of(elements)
    type = nil
    domain = []

    elements.each do |element|
      case element
      in { name: "data", attributes: [*, { name: "type", value: }, *] } then type = value
      in { name: "text" } then type ||= "text"
      in { name: "choice", elements: choices }
        domain.concat(choices.filter_map { |choice| choice.content if choice.name == "value" })
      in { name: "value", content: } then domain << content
      else nil
      end
    end

    [type, domain.uniq]
  end

  def walk(node, context, into, prefix_map)
    case node
    in { name: "attribute", elements: }
      type, domain = datatype_of(elements)
      into[:attributes] << {
        "name" => qualified_name(elements, prefix_map),
        "type" => type,
        "domain" => domain.empty? ? nil : domain,
        "required" => !context[:optional],
      }.compact

    in { name: "ref", attributes: [*, { name: "name", value: }, *] }
      into[:refs] << { "ref" => value, "quantifier" => context[:quantifier] }

    in { name: "optional", elements: }
      elements.each { |child| walk(child, context.merge(optional: true, quantifier: "optional"), into, prefix_map) }

    in { name: "zeroOrMore" | "oneOrMore" => quantifier, elements: }
      optional = quantifier == "zeroOrMore"
      elements.each { |child| walk(child, context.merge(optional:, quantifier:), into, prefix_map) }

    in { name: "element", elements: }
      walk_element(elements, context, into, prefix_map)

    in { name: "choice" | "interleave" | "group" | "define" | "start" | "mixed", elements: }
      elements.each { |child| walk(child, context, into, prefix_map) }

    else
      nil
    end
  end

  def walk_element(elements, context, into, prefix_map)
    name = qualified_name(elements, prefix_map)

    if into[:element].nil?
      into[:element] = name
      elements.each { |child| walk(child, context, into, prefix_map) unless child.name == "name" }
    else
      into[:inline] << { "element" => name, "quantifier" => context[:quantifier] }
    end
  end

  def rules
    doc = document
    prefix_map = prefixes(doc)

    collected = definitions(doc).to_h do |name, define|
      into = { element: nil, attributes: [], refs: [], inline: [] }
      walk(define, { optional: false, quantifier: "once" }, into, prefix_map)
      [name, into]
    end

    elements = collected.select { |_, rule| rule[:element] }.keys.to_set

    collected.to_h do |name, rule|
      children, groups = rule[:refs].partition { |ref| elements.include?(ref.fetch("ref")) }

      [name, {
        "name" => name,
        "element" => rule[:element],
        "attributes" => rule[:attributes],
        "children" => children.uniq,
        "groups" => groups.map { |ref| ref.fetch("ref") }.uniq,
        "inline" => rule[:inline],
      }]
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  rules = Grammar.rules
  nodes = rules.select { |_, rule| rule["element"] }
  path = Grammar::RNG.sub("#{Dir.pwd}/", "")

  puts "grammar: #{path}"
  puts "  definitions: #{rules.size} (#{nodes.size} elements, #{rules.size - nodes.size} groups)"
  puts

  %w[Class Property Repository].each do |name|
    rule = rules[name]
    next unless rule

    element = rule.fetch("element")
    groups = rule.fetch("groups")

    puts "#{name} -> #{element}"

    rule.fetch("attributes").each do |attribute|
      flag = attribute.fetch("required") ? "required" : "optional"
      domain = attribute["domain"] ? attribute.fetch("domain").inspect : ""
      puts format("  attr  %-26s %-12s %-9s %s", attribute["name"], attribute["type"], flag, domain)
    end

    rule.fetch("children").each do |child|
      puts format("  child %-26s %s", child.fetch("ref"), child.fetch("quantifier"))
    end

    puts "  groups: #{groups.join(", ")}" unless groups.empty?
    puts
  end
end
