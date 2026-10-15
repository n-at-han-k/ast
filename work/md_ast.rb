require_relative "md_nodes"

module MdAst
  Rule = Data.define(:text, :line)
  Example = Data.define(:lang, :code, :line)
  Reasoning = Data.define(:label, :text, :line)
  Prose = Data.define(:text, :line)
  Items = Data.define(:ordered, :entries, :line)
  Break = Data.define(:line)
  Table = Data.define(:rows, :line)
  Other = Data.define(:type, :line)

  Section = Data.define(:heading, :line, :rule, :examples, :reasoning, :terminated, :blocks)
  Document = Data.define(:path, :sections)

  module_function

  def parse(path)
    MdNodes.sections(MdNodes.parse_file(path)).map { |section| build_section(section) }.then do |sections|
      Document.new(path:, sections:)
    end
  end

  def build_section(section)
    blocks = classify(section[:body])

    Section.new(
      heading: section[:heading],
      line: section[:line],
      rule: blocks.first.is_a?(Rule) ? blocks.first : nil,
      examples: blocks.grep(Example),
      reasoning: blocks.grep(Reasoning),
      terminated: blocks.last.is_a?(Break),
      blocks:,
    )
  end

  def classify(nodes)
    seen_rule = false

    nodes.map do |node|
      block = node_to_block(node, seen_rule)
      seen_rule = true if block.is_a?(Rule)
      block
    end
  end

  def node_to_block(node, seen_rule)
    line = MdNodes.line_of(node)

    case node.type
    when :paragraph then paragraph_to_block(node, seen_rule, line)
    when :code_block
      Example.new(lang: node.fence_info.to_s.empty? ? nil : node.fence_info, code: MdNodes.literal(node), line:)
    when :list
      Items.new(ordered: node.list_type == :ordered, entries: MdNodes.children(node).map { |item| MdNodes.text_of(item).strip }, line:)
    when :thematic_break then Break.new(line:)
    when :table
      Table.new(rows: MdNodes.children(node).map { |row| MdNodes.children(row).map { |cell| MdNodes.text_of(cell).strip } }, line:)
    else Other.new(type: node.type, line:)
    end
  end

  def paragraph_to_block(node, seen_rule, line)
    MdNodes.bold_label(node).then do |label|
      if label.nil?
        Prose.new(text: MdNodes.text_of(node).strip, line:)
      elsif seen_rule
        Reasoning.new(label: label.delete_suffix(":"), text: MdNodes.text_of(node).strip, line:)
      else
        Rule.new(text: label, line:)
      end
    end
  end
end
