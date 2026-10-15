require_relative "markdown_types"

include MarkdownTypes

path = ARGV.fetch(0, "work/fixtures/correct.md")
document = MarkdownTypes.parse(path)

def dump(node, depth = 0)
  puts "#{"  " * depth}#{node.inspect} line=#{node.line}"
  node.children.each { |child| dump(child, depth + 1) }
end

puts "#{path}: typed tree"
dump(document)

puts
puts "composed patterns over the base types:"
document.children.each do |node|
  described = case node
              in Heading(header_level: 1, children: [Text(literal:)])
                "title #{literal.inspect}"
              in Heading(header_level: 2, children: [Text(literal:)])
                "section #{literal.inspect}"
              in Paragraph(children: [Strong => strong, *])
                "bold-led paragraph #{strong.text.inspect}"
              in Paragraph
                "paragraph"
              in CodeBlock(fenced?: true, fence_info: "")
                "fenced block, no language"
              in CodeBlock(fenced?: true, fence_info:)
                "fenced #{fence_info} block"
              in CodeBlock(fenced?: false)
                "indented block"
              in List(list_type: :ordered, list_start:, children:)
                "ordered list of #{children.size} from #{list_start}"
              in List(list_type: :bullet, children:)
                "bullet list of #{children.size}"
              in ThematicBreak
                "break"
              else
                node.name
              end

  puts "  line #{node.line}: #{described}"
end
