require "commonmarker-merge"
require "markdown-merge"
require "tree_haver"

path = ARGV.fetch(0, "work/markdown-rules/style-rules.md")
source = File.read(path)

tree = TreeHaver.with_backend("commonmarker") do
  TreeHaver.parser_for(:markdown).parse(source)
end

puts "tree:      #{tree.class}"
puts "tree api:  #{(tree.class.instance_methods - Object.instance_methods).sort.first(20).inspect}"

root = tree.respond_to?(:root_node) ? tree.root_node : tree.root
puts "root:      #{root.class} kind=#{root.respond_to?(:kind) ? root.kind : "?"}"
puts "root api:  #{(root.class.instance_methods - Object.instance_methods).sort.first(28).inspect}"

puts
puts "pattern matching hooks on the real objects:"
[tree, root].each do |object|
  puts "  #{object.class}: deconstruct=#{object.respond_to?(:deconstruct)} deconstruct_keys=#{object.respond_to?(:deconstruct_keys)}"
end

children = if root.respond_to?(:children)
             root.children
           elsif root.respond_to?(:each_child)
             root.each_child.to_a
           else
             []
           end

puts
puts "root children: #{children.size}"
children.first(12).each do |child|
  merge_type = child.respond_to?(:merge_type) ? child.merge_type : nil
  canonical = Markdown::Merge::MarkdownStructure.node_type(child)
  puts "  type=#{child.type.inspect} kind=#{child.respond_to?(:kind) ? child.kind.inspect : "-"} merge_type=#{merge_type.inspect} canonical=#{canonical.inspect}"
end

puts
puts "node pattern hooks: deconstruct=#{children.first.respond_to?(:deconstruct)} deconstruct_keys=#{children.first.respond_to?(:deconstruct_keys)}" if children.any?
