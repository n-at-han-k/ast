module SpecCorpus
  FENCE = /\A`{10,} example/
  CLOSE = /\A`{10,}\s*\z/
  SEPARATOR = ".".freeze
  TAB = "→".freeze

  module_function

  def examples(path)
    state = :outside
    current = []

    [].tap do |found|
      File.foreach(path) do |line|
        stripped = line.chomp

        case state
        when :outside
          state = :markdown if stripped.match?(FENCE)
        when :markdown
          if stripped == SEPARATOR
            found << current.join.tr(TAB, "\t")
            current = []
            state = :html
          else
            current << line
          end
        when :html
          state = :outside if stripped.match?(CLOSE)
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  ARGV.each do |path|
    found = SpecCorpus.examples(path)
    puts "#{path}: #{found.size} examples"
    puts "  first: #{found.first.inspect}"
    puts "  longest: #{found.max_by(&:length).length} chars"
  end
end
