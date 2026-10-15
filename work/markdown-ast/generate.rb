require "erb"
require "yaml"

module Generate
  CONFIG = File.expand_path("config.yml", __dir__)
  TEMPLATE = File.expand_path("templates/node.rb.erb", __dir__)
  OUTPUT = File.expand_path("node.rb", __dir__)

  WHITESPACE = %w[softbreak linebreak].freeze
  ALIASES = { "literal" => "string_content" }.freeze

  class Field
    TYPES = %w[string string? integer boolean enum].freeze

    def initialize(config)
      @config = config
      raise "unknown field type: #{type.inspect}" unless TYPES.include?(type)
    end

    def name = @config.fetch("name")
    def type = @config.fetch("type")
    def required = @config.fetch("required", false)
    def spec = @config["spec"]
    def domain = @config["domain"]

    def reader = name.delete_suffix("?")

    def predicate? = name.end_with?("?")

    def constant_name = "#{reader.upcase}_DOMAIN"

    def domain_literal
      return nil if domain.nil?

      case type
      when "integer" then domain.map { |value| Integer(value) }
      when "boolean" then [true, false]
      when "enum" then domain.map(&:to_sym)
      else domain
      end
    end
  end

  class NodeConfig
    def initialize(config)
      @config = config
    end

    def name = @config.fetch("name")
    def type = @config.fetch("type").to_sym
    def source = @config.fetch("source")
    def kind = @config.fetch("children", [])
    def spec_kind = @config["spec_children"]
    def unavailable = @config.fetch("unavailable", [])

    def fields
      @fields ||= @config.fetch("fields", []).map { |field| Field.new(field) }
    end

    def field_names = fields.map { |field| field.name.to_sym }

    def readers = fields.map { |field| field.reader.to_sym }

    def keys = [:type, :line, :end_line, :children, *field_names]

    def domains = fields.select(&:domain_literal)

    def unavailable_names = unavailable.map { |attribute| attribute.fetch("name") }

    def aliases
      fields.filter_map do |field|
        [ALIASES[field.reader], field.reader] if ALIASES.key?(field.reader)
      end + fields.filter_map { |field| [field.name, field.reader] if field.predicate? }
    end

    def text_field
      fields.map(&:reader).find { |reader| reader == "literal" }
    end

    def whitespace? = WHITESPACE.include?(type.to_s)
  end

  module_function

  def nodes
    YAML.load_file(CONFIG).fetch("nodes").map { |config| NodeConfig.new(config) }
  end

  def render
    ERB.new(File.read(TEMPLATE), trim_mode: "-").result_with_hash(nodes: nodes)
  end

  def write!
    render.tap { |source| File.write(OUTPUT, source) }
  end
end

if __FILE__ == $PROGRAM_NAME
  if ARGV.include?("--check")
    current = File.exist?(Generate::OUTPUT) ? File.read(Generate::OUTPUT) : nil
    fresh = Generate.render

    if current == fresh
      puts "work/markdown-ast/node.rb is up to date"
      exit 0
    end

    puts "work/markdown-ast/node.rb IS STALE: run ruby work/markdown-ast/generate.rb"
    exit 1
  end

  source = Generate.write!
  all = Generate.nodes

  puts "wrote work/markdown-ast/node.rb"
  puts "  #{all.size} node classes, #{source.lines.size} lines"
  puts "  with fields: #{all.count { |node| node.fields.any? }}"
  puts "  with a spec content model: #{all.count(&:spec_kind)}"
end
