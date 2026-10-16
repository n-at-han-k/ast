require "nokogiri"
require_relative "node"

module GirAst
  GIR_DIR = File.expand_path("gir", __dir__)

  module_function

  def parse(path)
    build(Nokogiri::XML(File.read(path)).root)
  end

  def parse_namespace(name)
    parse(File.join(GIR_DIR, "#{name}.gir"))
  end

  def build(element)
    klass = class_for(element)
    return nil if klass.nil?

    klass.new(
      line: element.line,
      children: element.elements.filter_map { |child| build(child) },
      **values_for(element, klass),
    )
  end

  def class_for(element)
    BY_ELEMENT[key_for(element)]
  end

  def key_for(element)
    prefix = element.namespace&.prefix

    prefix.nil? || prefix.empty? ? element.name : "#{prefix}:#{element.name}"
  end

  def values_for(element, klass)
    klass::ATTRIBUTES.filter_map do |field, attribute|
      value = read_attribute(element, attribute)
      [field, value] unless value.nil?
    end.to_h
  end

  def read_attribute(element, attribute)
    prefix, name = attribute.include?(":") ? attribute.split(":", 2) : [nil, attribute]
    return element[name] if prefix.nil?

    element.attribute_with_ns(name, element.document.root.namespace_definitions
      .find { |definition| definition.prefix == prefix }&.href)&.value
  end
end

if __FILE__ == $PROGRAM_NAME
  name = ARGV.fetch(0, "Gtk-4.0")
  started = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  repository = GirAst.parse_namespace(name)
  elapsed = format("%.1f", Process.clock_gettime(Process::CLOCK_MONOTONIC) - started)

  counts = {}
  repository.each_node { |node| counts[node.class.name.split("::").last] = counts.fetch(node.class.name.split("::").last, 0) + 1 }
  total = counts.values.sum

  puts "#{name}.gir parsed in #{elapsed}s"
  puts "  root: #{repository.inspect}"
  puts "  #{total} nodes across #{counts.size} types"
  puts
  counts.sort_by { |_, count| -count }.first(14).each do |type, count|
    puts format("  %-18s %6d", type, count)
  end

  classes = []
  repository.each_node { |node| classes << node if node.is_a?(GirAst::Class) }
  biggest = classes.max_by { |node| node.children.size }

  if biggest
    puts
    puts "largest class in #{name}:"
    puts "  #{biggest.inspect}"
    puts "  children: #{biggest.children.size}"

    by_type = biggest.children.group_by { |child| child.class.name.split("::").last }
    by_type.sort_by { |_, found| -found.size }.each do |type, found|
      puts format("    %-18s %4d", type, found.size)
    end
  end
end
