require_relative "md_rules"

module MdValidate
  TypedSection = MdRules::TypedSection

  module_function

  def verdict(section)
    case section
    in TypedSection(metadata: { indented: [TypedSection(metadata: { line: }), *] })
      [:indented_example, "the code block on line #{line} is indented, so it carries no language"]

    in TypedSection(metadata: { rule: TypedSection, examples: [TypedSection, *], reasoning: [TypedSection, *], terminated: true })
      [:ok, "rule, example and reasoning all present"]

    in TypedSection(metadata: { rule: TypedSection, examples: [TypedSection, *], reasoning: [TypedSection, *] })
      [:no_terminator, "does not end with a thematic break"]

    in TypedSection(metadata: { rule: TypedSection, examples: [TypedSection, *] })
      [:no_reasoning, "nothing states why the rule holds"]

    in TypedSection(name:, metadata: { rule: TypedSection })
      [:no_example, "#{name} is asserted with no code block"]

    in TypedSection(metadata: { blocks: [TypedSection(type:), *] })
      [:no_rule, "the section opens with #{type}, so no bold directive states the rule"]

    in TypedSection(name:)
      [:empty, "#{name} has no body"]
    end
  end

  def report(path)
    rules = MdRules.sections(path).reject(&:unclassified?)
    verdicts = rules.map { |section| [section, verdict(section)] }

    puts "#{path}: #{rules.size} rule section(s)"
    verdicts.each do |section, (kind, detail)|
      puts format("  %-4s %-40s %-18s %s", kind == :ok ? "ok" : "FAIL", section.name, kind, detail)
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
  abort "usage: ruby work/markdown-rules/md_validate.rb FILE.md [FILE.md ...] [--strict]" if paths.empty?

  paths.map { |path| MdValidate.report(path) }.then do |results|
    exit 1 if ARGV.include?("--strict") && !results.all?
  end
end
