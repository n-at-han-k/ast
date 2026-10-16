require "commonmarker-merge"
require "markdown-merge"
require "tree_haver"
require "ast-merge"

module MdRules
  SectionTyping = Ast::Merge::SectionTyping
  TypedSection = SectionTyping::TypedSection
  Structure = Markdown::Merge::MarkdownStructure

  RULE_HEADING = /\A\d+\.\s+\S/

  module_function

  def document(path, backend: "commonmarker")
    TreeHaver.with_backend(backend) do
      TreeHaver.parser_for(:markdown).parse(File.read(path))
    end.root_node
  end

  def classifier
    SectionTyping::CallableClassifier.new(
      lambda do |node|
        next nil unless Structure.node_type(node) == :heading
        next nil unless node.text.match?(RULE_HEADING)

        { type: :rule_section, name: node.text, node:, metadata: body_of(node) }
      end,
    )
  end

  def sections(path)
    document(path).then { |root| classifier.classify_all(root.children) }
  end

  def body_of(heading)
    blocks_after(heading).each_with_index.map { |node, index| typed_block(node, index) }.then do |blocks|
      {
        blocks:,
        rule: (blocks.first if blocks.first&.type == :rule),
        examples: blocks.select { |block| block.type == :example },
        indented: blocks.select { |block| block.type == :indented_example },
        reasoning: blocks.drop(1).select { |block| block.type == :reasoning },
        terminated: blocks.last&.type == :terminator,
      }
    end
  end

  def blocks_after(heading)
    [].tap do |blocks|
      sibling = heading.next_sibling
      while sibling && Structure.node_type(sibling) != :heading
        blocks << sibling
        sibling = sibling.next_sibling
      end
    end
  end

  def typed_block(node, index)
    TypedSection.new(type: role_of(node, index), name: nil, node:, metadata: { line: node.start_line })
  end

  def role_of(node, index)
    case Structure.node_type(node)
    when :paragraph then bold_directive?(node) ? (index.zero? ? :rule : :reasoning) : :prose
    when :code_block then node.fence_info.to_s.empty? ? :indented_example : :example
    when :thematic_break then :terminator
    when :list then :items
    else Structure.node_type(node)
    end
  end

  def bold_directive?(node)
    Structure.node_type(node.children.first) == :strong
  rescue StandardError
    false
  end
end
