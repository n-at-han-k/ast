require_relative "md_ast"

module MdValidate
  include MdAst

  RULE_HEADING = /\A\d+\.\s+\S/

  module_function

  def verdict(section)
    case section
    in MdAst::Section(rule: MdAst::Rule, examples: [MdAst::Example(lang: String), *], reasoning: [MdAst::Reasoning, *], terminated: true)
      [:ok, "rule, example and reasoning all present"]
    in MdAst::Section(rule: nil, blocks: [first, *])
      [:no_rule, "section opens with #{first.class.name.split("::").last.downcase}, not a bold directive"]
    in MdAst::Section(rule: nil)
      [:no_rule, "section is empty"]
    in MdAst::Section(examples: [])
      [:no_example, "no code block"]
    in MdAst::Section(examples: [*, MdAst::Example(lang: nil, line:), *])
      [:unfenced_example, "code block on line #{line} has no language"]
    in MdAst::Section(reasoning: [])
      [:no_reasoning, "no bold-labelled block after the rule"]
    in MdAst::Section(terminated: false)
      [:no_terminator, "does not end with a thematic break"]
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
      puts format("  %-4s %-28s %-18s %s", kind == :ok ? "ok" : "FAIL", section.heading, kind, detail)
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
  abort "usage: ruby work/md_validate.rb FILE.md [FILE.md ...] [--strict]" if paths.empty?

  paths.map { |path| MdValidate.report(path) }.then do |results|
    exit 1 if ARGV.include?("--strict") && !results.all?
  end
end
