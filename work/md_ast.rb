require "ast"
require_relative "md_nodes"

module MdAst
  class Node < ::AST::Node
    TYPE = :node

    attr_reader :line

    def initialize(children = [], properties = {})
      super(self.class::TYPE, children, properties)
    end

    def updated(_type = nil, children = nil, properties = nil)
      self.class.new(children || self.children, properties || { line: })
    end

    def deconstruct_keys(_keys)
      { line: }
    end
  end

  class Rule < Node
    TYPE = :rule

    def text = children[0]

    def deconstruct_keys(_keys) = super.merge(text:)
  end

  class Example < Node
    TYPE = :example

    def code = children[-1]

    def deconstruct_keys(_keys) = super.merge(code:)
  end

  class Fenced < Example
    TYPE = :fenced

    def lang = children[0]

    def deconstruct_keys(_keys) = super.merge(lang:)
  end

  class Indented < Example
    TYPE = :indented
  end

  class Reasoning < Node
    TYPE = :reasoning

    def label = children[0]
    def text = children[1]

    def deconstruct_keys(_keys) = super.merge(label:, text:)
  end

  class Prose < Node
    TYPE = :prose

    def text = children[0]

    def deconstruct_keys(_keys) = super.merge(text:)
  end

  class Items < Node
    TYPE = :items

    def ordered = children[0] == :ordered
    def entries = children[1]

    def deconstruct_keys(_keys) = super.merge(ordered:, entries:)
  end

  class Break < Node
    TYPE = :break
  end

  class Table < Node
    TYPE = :table

    def rows = children[0]

    def deconstruct_keys(_keys) = super.merge(rows:)
  end

  class Other < Node
    TYPE = :other

    def original = children[0]

    def deconstruct_keys(_keys) = super.merge(original:)
  end

  class Section < Node
    TYPE = :section

    attr_reader :heading

    def blocks = children
    def rule
      blocks.first if blocks.first.is_a?(Rule)
    end

    def examples = blocks.grep(Example)
    def reasoning = blocks.grep(Reasoning)
    def terminated? = blocks.last.is_a?(Break)

    def deconstruct_keys(_keys)
      { heading:, line:, blocks: }.tap do |keys|
        keys[:rule] = rule if rule
        keys[:examples] = examples if examples.any?
        keys[:reasoning] = reasoning if reasoning.any?
        keys[:terminated] = true if terminated?
      end
    end
  end

  class Document < Node
    TYPE = :document

    attr_reader :path

    def sections = children

    def deconstruct_keys(_keys) = { path:, sections: }
  end

  module_function

  def parse(path)
    MdNodes.sections(MdNodes.parse_file(path))
      .map { |section| build_section(section) }
      .then { |sections| Document.new(sections, { path: }) }
  end

  def build_section(section)
    section[:body].each_with_index.map { |node, index| block(node, index) }.then do |blocks|
      Section.new(blocks, { heading: section[:heading], line: section[:line] })
    end
  end

  def block(node, index)
    line = MdNodes.line_of(node)

    case node.type
    when :paragraph then paragraph(node, index, line)
    when :code_block then code_block(node, line)
    when :list
      Items.new([node.list_type, MdNodes.children(node).map { |item| MdNodes.text_of(item).strip }], { line: })
    when :thematic_break then Break.new([], { line: })
    when :table
      Table.new([MdNodes.children(node).map { |row| MdNodes.children(row).map { |cell| MdNodes.text_of(cell).strip } }], { line: })
    else Other.new([node.type], { line: })
    end
  end

  def code_block(node, line)
    node.fence_info.to_s.then do |fence|
      if fence.empty?
        Indented.new([MdNodes.literal(node)], { line: })
      else
        Fenced.new([fence, MdNodes.literal(node)], { line: })
      end
    end
  end

  def paragraph(node, index, line)
    MdNodes.bold_label(node).then do |label|
      if label.nil?
        Prose.new([MdNodes.text_of(node).strip], { line: })
      elsif index.zero?
        Rule.new([label], { line: })
      else
        Reasoning.new([label.delete_suffix(":"), body_after(node, label)], { line: })
      end
    end
  end

  def body_after(node, label)
    MdNodes.text_of(node).strip.delete_prefix(label).strip
  end
end
