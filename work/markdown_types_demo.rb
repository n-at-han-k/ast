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
              in Heading(level: 1, children: [Text(content:)])
                "title #{content.inspect}"
              in Heading(level: 2, children: [Text(content:)])
                "section #{content.inspect}"
              in Paragraph(children: [Strong => strong, *])
                "bold-led paragraph #{strong.text.inspect}"
              in Paragraph
                "paragraph"
              in CodeBlock(lang: String => lang)
                "fenced #{lang} block"
              in CodeBlock(lang: nil)
                "indented block"
              in List(ordered: true, children:)
                "ordered list of #{children.size}"
              in List(ordered: false, children:)
                "bullet list of #{children.size}"
              in ThematicBreak
                "break"
              else
                node.name
              end

  puts "  line #{node.line}: #{described}"
end
