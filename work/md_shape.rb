require_relative "md_nodes"

def describe(node)
  case node.type
  when :paragraph
    MdNodes.bold_label(node).then { |label| label ? "para[**#{label}**]" : "para" }
  when :code_block
    node.fence_info.to_s.empty? ? "code[indented]" : "code[#{node.fence_info}]"
  when :list
    "list[#{node.list_type}]"
  else
    node.type.to_s
  end
end

path = ARGV.fetch(0) { abort "usage: ruby work/md_shape.rb FILE.md" }
doc = MdNodes.parse_file(path)

puts "#{path}: section shapes"
MdNodes.sections(doc).each do |section|
  puts
  puts "h#{section[:level]} (line #{section[:line]}) #{section[:heading]}"
  puts "    #{section[:body].map { |node| describe(node) }.join(' ')}"
end
