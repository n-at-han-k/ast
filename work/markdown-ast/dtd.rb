module Dtd
  HASH = "#".freeze
  PCDATA = "(#PCDATA)".freeze
  REQUIRED = "#REQUIRED".freeze
  FIXED = Regexp.new(HASH + 'FIXED\s+"([^"]*)"').freeze

  ENTITY = /<!ENTITY\s+%\s+(?<name>\w+)\s+'(?<value>[^']+)'\s*>/m
  ELEMENT = /<!ELEMENT\s+(?<name>[\w:]+)\s+(?<content>.+?)>/m
  ATTLIST = /<!ATTLIST\s+(?<name>[\w:]+)\s+(?<body>.+?)>/m

  IGNORED_ATTRIBUTES = ["xmlns", "xml:space", "sourcepos"].freeze

  module_function

  def parse(path)
    text = File.read(path)
    entities = text.scan(ENTITY).to_h { |name, value| [name, value.split("|").map(&:strip)] }

    elements = text.scan(ELEMENT).to_h do |name, content|
      [name, { content: content.strip, children: children_for(content.strip, entities) }]
    end

    text.scan(ATTLIST).each do |name, body|
      next unless elements.key?(name)

      elements[name][:attributes] = attributes_for(body)
    end

    { entities:, elements: }
  end

  def children_for(content, entities)
    return [] if content == "EMPTY"
    return :text if content.delete(" ") == PCDATA

    content.scan(/%(\w+);|\b([a-z_]+)\b/).flat_map do |entity, literal|
      entity ? entities.fetch(entity, []) : [literal].compact
    end.uniq - ["PCDATA"]
  end

  def attributes_for(body)
    body.split("\n").map(&:strip).reject(&:empty?)
        .filter_map { |line| parse_attribute(line) }
        .reject { |attribute| IGNORED_ATTRIBUTES.include?(attribute[:name]) }
  end

  def parse_attribute(line)
    match = line.match(/\A(?<name>[\w:]+)\s+(?<rest>.+?)\s*>?\z/)
    return nil unless match

    rest = match[:rest]

    {
      name: match[:name],
      domain: rest[/\(([^)]+)\)/, 1]&.split("|")&.map(&:strip),
      required: rest.include?(REQUIRED),
      fixed: rest[FIXED, 1],
    }
  end
end

if __FILE__ == $PROGRAM_NAME
  path = ARGV.fetch(0, "refs/commonmark-spec/CommonMark.dtd")
  schema = Dtd.parse(path)

  puts path
  puts
  puts "entities:"
  schema[:entities].each { |name, members| puts "  #{name}: #{members.join(", ")}" }
  puts
  puts "#{schema[:elements].size} elements"

  schema[:elements].each do |name, element|
    children = element[:children] == :text ? "text content" : element[:children].join(", ")

    puts
    puts "  #{name}"
    puts "    content:  #{element[:content]}"
    puts "    children: #{children.empty? ? "(none)" : children}"

    (element[:attributes] || []).each do |attribute|
      domain = attribute[:domain] ? attribute[:domain].join("|") : "CDATA"
      puts "    attr:     #{attribute[:name]} (#{domain}) #{attribute[:required] ? "required" : "optional"}"
    end
  end
end
