require_relative "md_ast"

module MdValidate
  include MdAst

  RULE_HEADING = /\A\d+\.\s+\S/

  module_function

  def verdict(section)
    case section
    in { examples: [*, Indented => block, *] }
      [:indented_example, "the code block on line #{block.line} is indented, so it carries no language"]

    in { rule: Rule, examples: [Fenced, *], reasoning: [Reasoning, *], terminated: true }
      [:ok, "rule, example and reasoning all present"]

    in { rule: Rule, examples: [Fenced, *], reasoning: [Reasoning, *] }
      [:no_terminator, "does not end with a thematic break"]

    in { rule: Rule, examples: [Fenced, *] }
      [:no_reasoning, "nothing states why the rule holds"]

    in { rule: Rule(text:) }
      [:no_example, "#{text[0, 40].inspect} is asserted with no example"]

    in { blocks: [opening, *] }
      [:no_rule, "the section opens with #{opening.type}, so no bold directive states the rule"]

    in { heading: }
      [:empty, "#{heading.inspect} has no body"]
    end
  end

  def rule_sections(document)
    document.sections.select { |section| section.heading.match?(RULE_HEADING) }
  end

  def report(path)
    document = MdAst.parse(path)
    rules = rule_sections(document)
    verdicts = rules.map { |section| [section, verdict(section)] }

    puts "#{path}: #{rules.size} rule section(s)"
    verdicts.each do |section, (kind, detail)|
      puts format("  %-4s %-40s %-18s %s", kind == :ok ? "ok" : "FAIL", section.heading, kind, detail)
    end

    verdicts.count { |_, (kind, _)| kind == :ok }.then do |passed|
      puts "  #{passed}/#{rules.size} conform"
      puts
      passed == rules.size
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  paths = ARGV.reject { |argument| argument.start_with?("--") }
  abort "usage: ruby work/md_validate.rb FILE.md [FILE.md ...] [--strict|--sexp]" if paths.empty?

  if ARGV.include?("--sexp")
    paths.each { |path| puts MdAst.parse(path).to_sexp }
  else
    paths.map { |path| MdValidate.report(path) }.then do |results|
      exit 1 if ARGV.include?("--strict") && !results.all?
    end
  end
end
