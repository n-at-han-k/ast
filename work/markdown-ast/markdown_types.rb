require "commonmarker"
require_relative "node"

module MarkdownTypes
  SPECIMEN = File.expand_path("kitchen-sink.md", __dir__)

  DEFAULT_OPTIONS = { extension: Commonmarker::Config::OPTIONS[:extension] }.freeze

  DISCOVERY_OPTIONS = {
    extension: Commonmarker::Config::OPTIONS[:extension]
      .to_h { |name, value| [name, [true, false].include?(value) ? true : value] }
      .merge(front_matter_delimiter: "---"),
  }.freeze

  class UnknownType < StandardError
    def initialize(type)
      super("no generated class for #{type.inspect}: regenerate with build_config.rb then generate.rb")
    end
  end

  module_function

  def parse(path, options: DEFAULT_OPTIONS)
    parse_string(File.read(path), options:)
  end

  def parse_string(source, options: DEFAULT_OPTIONS)
    build(Commonmarker.parse(source, options:))
  end

  def build(node)
    klass = BY_TYPE.fetch(node.type) { raise UnknownType, node.type }
    position = node.source_position

    klass.new(
      line: position[:start_line],
      end_line: position[:end_line],
      children: children_of(node).map { |child| build(child) },
      **fields_of(node, klass),
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

  def fields_of(node, klass)
    klass::FIELDS.to_h { |field| [field.to_s.delete_suffix("?").to_sym, node.public_send(field)] }
  end

  def class_name_for(type)
    BY_TYPE.fetch(type).name.split("::").last
  end
end
