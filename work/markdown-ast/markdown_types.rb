require "commonmarker"

module MarkdownTypes
  SPECIMEN = File.expand_path("kitchen-sink.md", __dir__)

  DEFAULT_OPTIONS = { extension: Commonmarker::Config::OPTIONS[:extension] }.freeze

  DISCOVERY_OPTIONS = {
    extension: Commonmarker::Config::OPTIONS[:extension]
      .to_h { |name, value| [name, [true, false].include?(value) ? true : value] }
      .merge(front_matter_delimiter: "---"),
  }.freeze

  PROPERTY_METHODS = (Commonmarker::Node.instance_methods - Object.instance_methods - Enumerable.instance_methods)
    .reject { |name| name.to_s.end_with?("=") }
    .sort
    .freeze

  POSITIONAL = %i[source_position].freeze
  ALIASES = { string_content: :literal }.freeze
  WHITESPACE = %i[softbreak linebreak].freeze

  class Node
    attr_reader :line, :end_line, :children, :fields

    def initialize(line:, end_line:, children:, **fields)
      @line = line
      @end_line = end_line
      @children = children
      @fields = fields
      fields.each { |name, value| instance_variable_set(:"@#{name.to_s.delete_suffix("?")}", value) }
    end

    def type = self.class::TYPE

    def deconstruct = children

    def deconstruct_keys(_keys)
      { type:, line:, end_line:, children: }.merge(fields)
    end

    def text
      return " " if WHITESPACE.include?(type)
      return literal.to_s if fields.key?(:literal)

      children.map(&:text).join
    end

    def name
      self.class.name.split("::").last
    end

    def inspect
      shown = fields.map { |field, value| [field, value.inspect].join(": ") }.join(", ")
      [name, "(", shown, ")"].join
    end
  end

  BY_TYPE = {}
  TYPES = {}

  module_function

  def properties_of(node)
    PROPERTY_METHODS.select { |method| node.node_supports?(method) == true }
  end

  def fields_of(node)
    properties_of(node) - POSITIONAL - ALIASES.keys
  end

  def class_name_for(type)
    type.to_s.split("_").map(&:capitalize).join
  end

  def register(node)
    BY_TYPE.fetch(node.type) do
      fields = fields_of(node)

      Class.new(Node).tap do |klass|
        klass.const_set(:TYPE, node.type)

        fields.each do |field|
          reader = field.to_s.delete_suffix("?")
          klass.send(:attr_reader, reader)
          klass.send(:alias_method, field, reader) unless field.to_s == reader
        end

        ALIASES.each do |alias_name, target|
          klass.send(:alias_method, alias_name, target) if fields.include?(target)
        end

        const_set(class_name_for(node.type), klass)
        TYPES[node.type] = fields
        BY_TYPE[node.type] = klass
      end
    end
  end

  def discover!(path = SPECIMEN)
    Commonmarker.parse(File.read(path), options: DISCOVERY_OPTIONS).walk { |node| register(node) }
    BY_TYPE.keys
  end

  def parse(path, options: DEFAULT_OPTIONS)
    parse_string(File.read(path), options:)
  end

  def parse_string(source, options: DEFAULT_OPTIONS)
    build(Commonmarker.parse(source, options:))
  end

  def build(node)
    klass = register(node)
    position = node.source_position

    klass.new(
      line: position[:start_line],
      end_line: position[:end_line],
      children: children_of(node).map { |child| build(child) },
      **TYPES.fetch(node.type).to_h { |field| [field, node.public_send(field)] },
    )
  end

  def children_of(node)
    [].tap do |kids|
      child = node.first_child
      while child
        kids << child
        child = child.next_sibling
      end
    end
  end

  discover!
end
