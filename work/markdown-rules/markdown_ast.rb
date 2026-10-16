require "commonmarker"

HASH = "#".freeze

OPTIONS = {
  extension: {
    table: true,
    strikethrough: true,
    tasklist: true,
    autolink: true,
    footnotes: true,
  },
}.freeze

DETAILS = {
  heading: ->(node) { "level=#{node.header_level}" },
  code_block: ->(node) { node.fence_info.to_s.empty? ? "indented" : "lang=#{node.fence_info}" },
  link: ->(node) { "url=#{node.url}" },
  image: ->(node) { "url=#{node.url}" },
  list: ->(node) { "#{node.list_type} tight=#{node.list_tight}" },
}.freeze

class MarkdownAst
  def initialize(source)
    @doc = Commonmarker.parse(source, options: OPTIONS)
  end

  attr_reader :doc

  def each_node(node = doc, depth = 0, &block)
    block.call(node, depth)
    child = node.first_child
    while child
      each_node(child, depth + 1, &block)
      child = child.next_sibling
    end
  end

  def counts
    {}.tap do |tally|
      each_node { |node, _| tally[node.type] = tally.fetch(node.type, 0) + 1 }
    end
  end

  def outline
    [].tap do |headings|
      each_node do |node, _|
        headings << [node.header_level, text_of(node)] if node.type == :heading
      end
    end
  end

  def text_of(node)
    "".dup.tap do |buffer|
      each_node(node) { |inner, _| buffer << literal(inner).to_s if inner.type == :text }
    end
  end

  def literal(node)
    node.string_content
  rescue StandardError
    nil
  end

  def line_of(node)
    node.source_position[:start_line]
  rescue StandardError
    nil
  end
end

def excerpt(text, limit = 48)
  text.to_s.gsub(/\s+/, " ").strip.then do |flat|
    flat.length > limit ? "#{flat[0, limit - 1]}…" : flat
  end
end

path = ARGV.fetch(0) { abort "usage: ruby work/markdown-rules/markdown_ast.rb FILE.md [--outline|--counts]" }
mode = ARGV[1]
ast = MarkdownAst.new(File.read(path))

case mode
when "--outline"
  puts "#{path}: outline"
  ast.outline.each do |level, text|
    puts "#{"  " * (level - 1)}#{HASH * level} #{excerpt(text, 70)}"
  end
when "--counts"
  puts "#{path}: #{ast.counts.values.sum} nodes"
  ast.counts.sort_by { |type, n| [-n, type.to_s] }.each do |type, n|
    puts format("  %-14s %4d", type, n)
  end
else
  puts "#{path}: markdown AST"
  ast.each_node do |node, depth|
    detail = DETAILS[node.type]&.call(node)
    body = excerpt(ast.literal(node))
    line = ast.line_of(node)
    puts [
      "  " * depth,
      node.type,
      line ? " (line #{line})" : "",
      detail ? "  #{detail}" : "",
      body.empty? ? "" : "  #{body.inspect}",
    ].join
  end
end
