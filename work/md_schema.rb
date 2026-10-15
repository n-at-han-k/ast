require_relative "md_nodes"

RULE_HEADING = /\A\d+\.\s+\S/

class RuleSection
  def initialize(section)
    @section = section
  end

  attr_reader :section

  def heading = section[:heading]
  def line = section[:line]
  def body = section[:body]

  def rule
    body.first.then { |first| first && MdNodes.bold_label(first) }
  end

  def examples
    body.select { |node| node.type == :code_block }
  end

  def fenced_examples
    examples.reject { |node| node.fence_info.to_s.empty? }
  end

  def reasoning
    body.drop(1).filter_map { |node| MdNodes.bold_label(node) }
  end

  def terminated?
    body.last&.type == :thematic_break
  end

  def violations
    [].tap do |found|
      found << "no rule: first block is #{body.first&.type || 'empty'}, not a bold directive" unless rule
      found << "no example: section has no code block" if examples.empty?
      found << "unfenced example: #{examples.size - fenced_examples.size} code block(s) without a language" if fenced_examples.size < examples.size
      found << "no reasoning: no bold-labelled block after the rule" if reasoning.empty?
      found << "not terminated by a thematic break" unless terminated?
    end
  end

  def conforms? = violations.empty?
end

path = ARGV.fetch(0) { abort "usage: ruby work/md_schema.rb FILE.md [--strict]" }
strict = ARGV.include?("--strict")
doc = MdNodes.parse_file(path)

all = MdNodes.sections(doc)
rules = all.select { |section| section[:heading].match?(RULE_HEADING) }.map { |section| RuleSection.new(section) }
skipped = all.reject { |section| section[:heading].match?(RULE_HEADING) }

puts "#{path}: #{rules.size} rule section(s), #{skipped.size} other section(s)"
puts

if rules.empty?
  puts "No sections match the rule/example/reasoning schema."
  puts "A rule section is an h2 titled \"N. Name\" containing, in order:"
  puts "  1. a paragraph opening with a bold directive        (the rule)"
  puts "  2. one or more fenced code blocks                   (the example)"
  puts "  3. a paragraph opening with a bold label            (the reasoning)"
  puts "  4. a closing thematic break"
end

rules.each do |rule|
  status = rule.conforms? ? "ok  " : "FAIL"
  puts "#{status} line #{rule.line}  #{rule.heading}"
  puts "       rule:      #{rule.rule ? rule.rule[0, 64] : '(missing)'}"
  puts "       examples:  #{rule.examples.size} (#{rule.fenced_examples.size} fenced)"
  puts "       reasoning: #{rule.reasoning.empty? ? '(missing)' : rule.reasoning.join(', ')}"
  rule.violations.each { |violation| puts "       - #{violation}" }
  puts
end

failing = rules.reject(&:conforms?)
puts "#{rules.size - failing.size}/#{rules.size} conform"
skipped.each { |section| puts "skipped (not a numbered rule): #{section[:heading]}" }

exit 1 if strict && failing.any?
