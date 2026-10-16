require "prism"

require_relative "lib/ruby_comments"
require_relative "lib/prism_visitors"

BUDGET = Integer(ENV.fetch("MAX", 72))
H = 35.chr

SAMPLE = [
  "#{H} frozen_string_literal: true",
  "",
  "module Greeting",
  "  #{H} A formatter that turns a name into a greeting, with the title taken from",
  "  #{H} the constructor so that callers can pick their own.",
  "  #{H}",
  "  #{H} @param title [String] the honorific placed in front of the name, which runs long",
  "  def greet(name) = name",
  "",
  "  #{H} rubocop:disable Demo/CommentLineLength, Style/Documentation, Layout/LineLength",
  "  def shout(text) = text.upcase",
  "  #{H} rubocop:enable Demo/CommentLineLength, Style/Documentation, Layout/LineLength",
  "end",
  "",
  "class Lister < Prism::Visitor",
  "  def visit_class_node(node)",
  "    @scope << node.name",
  "    super",
  "  end",
  "",
  "  def visit_module_node(node)",
  "    @scope << node.name",
  "  end",
  "end",
  "",
  "#{H} an orphan paragraph at the end of the file, long enough to be over the budget",
].join("\n") + "\n"

path = ARGV.first
result = Prism.parse(path ? File.read(path) : SAMPLE)
result.attach_comments!

documented = result.value.breadth_first_search_all { |node| node.location.leading_comments.any? }
attached = documented.flat_map { |owner| owner.location.leading_comments }

blocks = documented.flat_map { |owner|
  RubyComments::PARAGRAPHS.call(owner.location.leading_comments)
                          .map { |run| RubyComments::Block.new(comments: run, owner: owner, budget: BUDGET) }
}.concat(
  RubyComments::PARAGRAPHS.call(result.comments - attached)
                          .map { |run| RubyComments::Block.new(comments: run, budget: BUDGET) },
).sort_by(&:line)

puts "#{path || "(sample)"}: #{blocks.length} RubyComments::Block, budget #{BUDGET}"
puts

blocks.each do |block|
  owner =
    case block
    in RubyComments::Block(owner: Prism::DefNode(name:)) then "def #{name}"
    in RubyComments::Block(owner: Prism::ClassNode | Prism::ModuleNode => node) then node.constant_path.slice
    else "-"
    end

  puts format(
    "  line %-4d %3d chars  overrun %-5d %-18s tag %-8s directive %-8s wrappable %s",
    block.line, block.length, block.overrun, owner,
    block.tag || "-", block.directive || "-", block.wrappable,
  )
end

puts

hooks = result.value.breadth_first_search_all(&PrismVisitors::VISITORS).flat_map { |visitor|
  visitor.body.body.filter_map { |statement|
    PrismVisitors::Hook.new(node: statement, visitor: visitor) if statement.is_a?(Prism::DefNode)
  }
}

puts "#{hooks.length} PrismVisitors::Hook"
hooks.each do |hook|
  puts format("  line %-4d %-20s base %-14s descends %s", hook.line, hook.name, hook.base, hook.descends)
end
