require "commonmarker-merge"
require "markdown-merge"
require "tree_haver"

module MarkdownTypes
  SPEC = {
    "Document" => [:document, []],
    "Heading" => [:heading, [:level]],
    "Paragraph" => [:paragraph, []],
    "CodeBlock" => [:code_block, [:lang, :code]],
    "HtmlBlock" => [:html_block, [:content]],
    "BlockQuote" => [:block_quote, []],
    "List" => [:list, [:ordered, :tight]],
    "ListItem" => [:list_item, []],
    "ThematicBreak" => [:thematic_break, []],
    "Table" => [:table, []],
    "TableRow" => [:table_row, []],
    "TableCell" => [:table_cell, []],
    "FootnoteDefinition" => [:footnote_definition, []],
    "Text" => [:text, [:content]],
    "Code" => [:code, [:content]],
    "Emph" => [:emph, []],
    "Strong" => [:strong, []],
    "Link" => [:link, [:url, :title]],
    "Image" => [:image, [:url, :title]],
    "SoftBreak" => [:softbreak, []],
    "LineBreak" => [:linebreak, []],
    "HtmlInline" => [:html_inline, [:content]],
    "Unknown" => [:unknown, [:original]],
  }.freeze

  class Node
    attr_reader :line, :children

    def initialize(line:, children:, **fields)
      @line = line
      @children = children
      @fields = fields
      fields.each { |name, value| instance_variable_set(:"@#{name}", value) }
    end

    attr_reader :fields

    def type = self.class::TYPE

    def deconstruct = children

    def deconstruct_keys(_keys)
      { type:, line:, children: }.merge(fields)
    end

    def text
      children.map(&:text).join
    end

    def name
      self.class.name.split("::").last
    end

    def inspect
      shown = fields.map { |field, value| [field, value.inspect].join(": ") }.join(", ")
      [name, "(", shown, ")"].join
    end
  end

  SPEC.each do |class_name, (type, fields)|
    klass = Class.new(Node)
    klass.const_set(:TYPE, type)
    fields.each { |field| klass.send(:attr_reader, field) }
    const_set(class_name, klass)
  end

  Text.define_method(:text) { content.to_s }
  Code.define_method(:text) { content.to_s }
  CodeBlock.define_method(:text) { code.to_s }
  SoftBreak.define_method(:text) { " " }
  LineBreak.define_method(:text) { " " }

  BY_TYPE = SPEC.to_h { |class_name, (type, _)| [type, const_get(class_name)] }.freeze

  module_function

  def parse(path, backend: "commonmarker")
    TreeHaver.with_backend(backend) do
      TreeHaver.parser_for(:markdown).parse(File.read(path))
    end.root_node.then { |root| build(root) }
  end

  def build(node)
    canonical = Markdown::Merge::NodeTypeNormalizer.canonical_type(node.type.to_sym, :commonmarker)

    BY_TYPE.fetch(canonical, Unknown).then do |klass|
      klass.new(
        line: node.start_line,
        children: node.children.map { |child| build(child) },
        **fields_for(canonical, node),
      )
    end
  end

  def fields_for(canonical, node)
    inner = node.inner_node

    case canonical
    when :heading then { level: node.header_level }
    when :code_block then { lang: blank_to_nil(node.fence_info), code: inner.string_content }
    when :text, :code, :html_block, :html_inline then { content: inner.string_content }
    when :link, :image then { url: blank_to_nil(node.url), title: blank_to_nil(node.title) }
    when :list then { ordered: inner.list_type == :ordered, tight: inner.list_tight }
    when :unknown then { original: node.type.to_sym }
    else {}
    end
  end

  def blank_to_nil(value)
    value.to_s.empty? ? nil : value.to_s
  end
end
