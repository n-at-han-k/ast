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
    def type = @config.fetch("type")
    def domain = @config["domain"]
    def writable = @config.fetch("writable", false)

    def reader = name.tr("-", "_").to_sym

    def constant_name = "#{reader.to_s.upcase}_DOMAIN"
  end

  class NodeConfig
    def initialize(config)
      @config = config
    end

    def type = @config.fetch("name")
    def kind = @config.fetch("kind")
    def gtype = @config["gtype"]
    def namespace = @config.fetch("namespace")
    def parent = @config["parent"]
    def implements = @config.fetch("implements", [])
    def basename = type.split(".").last

    def interface? = kind == "interface"

    def qualified = "#{namespace}::#{basename}"

    def fields
      @fields ||= @config.fetch("fields", []).map { |field| Field.new(field) }
    end

    def readers = fields.map(&:reader)

    def domains = fields.select { |field| field.domain && !field.domain.empty? }

    def property_map
      fields.to_h { |field| [field.reader, field.name] }
    end

    def declaration
      return "module #{basename}" if interface?
      return "class #{basename} < GtkAst::Node" if parent.nil?

      "class #{basename} < #{reference(parent)}"
    end

    def includes
      implements.map { |name| reference(name) }
    end

    def keys_expression
      parts = []
      parts << "superclass::KEYS" unless interface?
      parts.concat(includes.map { |name| "#{name}::FIELDS" })
      parts << "FIELDS"

      parts.size == 1 ? "FIELDS.dup" : "(#{parts.join(" + ")}).uniq"
    end

    def reference(name)
      other_namespace, basename = name.split(".")
      other_namespace == namespace ? basename : "GtkAst::#{other_namespace}::#{basename}"
    end
  end

  module_function

  def nodes
    @nodes ||= YAML.load_file(CONFIG, aliases: true).fetch("nodes").map { |config| NodeConfig.new(config) }
  end

  def kinds
    @kinds ||= nodes.to_h { |node| [node.type, node.kind] }
  end

  def kind_of(name)
    kinds[name]
  end

  def ordered
    resolved = []
    seen = {}
    pending = nodes.to_h { |node| [node.type, node] }

    visit = lambda do |node|
      return if seen[node.type]

      seen[node.type] = true

      [node.parent, *node.implements].compact.each do |dependency|
        other = pending[dependency]
        visit.call(other) if other
      end

      resolved << node
    end

    nodes.each { |node| visit.call(node) }
    resolved
  end

  def namespaces
    ordered.group_by(&:namespace)
  end

  def render
    ERB.new(File.read(TEMPLATE), trim_mode: "-")
       .result_with_hash(namespaces: namespaces, all_nodes: ordered)
  end

  def write!
    render.tap { |source| File.write(OUTPUT, source) }
  end
end

require "set"

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
  all = Generate.ordered
  interfaces = all.count(&:interface?)

  puts "wrote work/gtk-ast/node.rb"
  puts "  #{all.size} types (#{all.size - interfaces} classes, #{interfaces} interface modules)"
  puts "  #{source.lines.size} lines, #{format("%.1f", source.bytesize / 1_048_576.0)}M"
  puts "  namespaces: #{Generate.namespaces.keys.sort.join(", ")}"
end
