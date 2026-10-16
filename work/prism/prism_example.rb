require "prism"

class MethodLister < Prism::Visitor
  Entry = Struct.new(:scope, :name, :params, :line, :doc)

  attr_reader :entries

  def initialize
    @entries = []
    @scope = []
  end

  def visit_class_node(node)
    push_scope(node.constant_path.slice) { super }
  end

  def visit_module_node(node)
    push_scope(node.constant_path.slice) { super }
  end

  def visit_def_node(node)
    separator = node.receiver ? "." : "#"
    @entries << Entry.new(
      @scope.join("::"),
      separator + node.name.to_s,
      node.parameters&.slice,
      node.location.start_line,
      leading_comment(node),
    )
    super
  end

  private

  def push_scope(name)
    @scope.push(name)
    yield
  ensure
    @scope.pop
  end

  def leading_comment(node)
    lines = node.location.leading_comments.map do |comment|
      comment.location.slice.byteslice(1..).to_s.strip
    end
    lines.empty? ? nil : lines.join(" ")
  end
end

path = ARGV.fetch(0) { abort "usage: ruby work/prism/prism_example.rb FILE.rb" }
result = Prism.parse_file(path)
result.attach_comments!

unless result.success?
  result.errors.each { |error| warn "#{path}:#{error.location.start_line}: #{error.message}" }
  exit 1
end

lister = MethodLister.new
result.value.accept(lister)

puts "#{path}: #{lister.entries.size} method(s)"
lister.entries.each do |entry|
  scope = entry.scope.empty? ? "(top level)" : entry.scope
  params = entry.params ? "(" + entry.params + ")" : ""
  label = scope + entry.name + params
  puts format("  %-34s line %-4d %s", label, entry.line, entry.doc)
end
