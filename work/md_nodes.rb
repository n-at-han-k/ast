require "commonmarker"

module MdNodes
  OPTIONS = {
    extension: {
      table: true,
      strikethrough: true,
      tasklist: true,
      autolink: true,
      footnotes: true,
    },
  }.freeze

  LITERAL_TYPES = [:text, :code, :code_block, :html_inline, :html_block].freeze

  module_function

  def parse_file(path)
    Commonmarker.parse(File.read(path), options: OPTIONS)
  end

  def each_node(node, depth = 0, &block)
    block.call(node, depth)
    children(node).each { |child| each_node(child, depth + 1, &block) }
  end

  def children(node)
    [].tap do |kids|
      child = node.first_child
      while child
        kids << child
        child = child.next_sibling
      end
    end
  end

  def literal(node)
    node.string_content
  rescue StandardError
    nil
  end

  def text_of(node)
    "".dup.tap do |buffer|
      each_node(node) do |inner, _|
        buffer << literal(inner).to_s if [:text, :code].include?(inner.type)
      end
    end
  end

  def line_of(node)
    node.source_position[:start_line]
  rescue StandardError
    nil
  end

  def sections(doc, level: 2)
    [].tap do |found|
      children(doc).each do |node|
        if node.type == :heading && node.header_level <= level
          found << { heading: text_of(node), level: node.header_level, line: line_of(node), body: [] }
        elsif found.any?
          found.last[:body] << node
        end
      end
    end
  end

  def bold_label(node)
    return nil unless node.type == :paragraph

    children(node).first.then do |first|
      first && first.type == :strong ? text_of(first).strip : nil
    end
  end
end
