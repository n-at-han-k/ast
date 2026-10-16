require "erb"
require "yaml"

module Generate
  CONFIG = File.expand_path("config.yml", __dir__)
  TEMPLATE = File.expand_path("templates/node.rb.erb", __dir__)
  OUTPUT = File.expand_path("node.rb", __dir__)

  class Field
    def initialize(config)
      @config = config
    end

    def name = @config.fetch("name")
    def attribute = @config.fetch("attribute")
    def type = @config.fetch("type")
    def domain = @config["domain"]
    def required = @config.fetch("required", false)

    def reader = name.to_sym

    def constant_name = "#{name.upcase}_DOMAIN"
  end

  class NodeConfig
    def initialize(config)
      @config = config
    end

    def name = @config.fetch("name")
    def definition = @config.fetch("definition")
    def element = @config.fetch("element")

    def element_key = element.delete_prefix("core:")

    def fields
      @fields ||= @config.fetch("fields", []).map { |field| Field.new(field) }.uniq(&:name)
    end

    def readers = fields.map(&:reader)

    def attribute_map = fields.to_h { |field| [field.reader, field.attribute] }

    def required = fields.select(&:required).map(&:reader)

    def domains = fields.select { |field| field.domain && !field.domain.empty? }

    def child_map
      @config.fetch("children", []).to_h do |child|
        [child.fetch("name").to_sym, child.fetch("quantifier").to_sym]
      end
    end
  end

  module_function

  def nodes
    @nodes ||= YAML.load_file(CONFIG).fetch("nodes").map { |config| NodeConfig.new(config) }
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

    if current == Generate.render
      puts "work/gtk-ast/node.rb is up to date"
      exit 0
    end

    puts "work/gtk-ast/node.rb IS STALE: run ruby work/gtk-ast/generate.rb"
    exit 1
  end

  source = Generate.write!
  all = Generate.nodes

  puts "wrote work/gtk-ast/node.rb"
  puts "  #{all.size} node classes, #{source.lines.size} lines"
  puts "  fields:   #{all.sum { |node| node.readers.size }}"
  puts "  children: #{all.sum { |node| node.child_map.size }}"
  puts "  domains:  #{all.sum { |node| node.domains.size }}"
end
