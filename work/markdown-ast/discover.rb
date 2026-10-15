require_relative "markdown_types"
require_relative "spec_corpus"

module Discover
  SOURCES = {
    "commonmark" => "refs/commonmark-spec/spec.txt",
    "gfm" => "refs/cmark-gfm/test/spec.txt",
  }.freeze

  module_function

  def documents
    {}.tap do |sources|
      SOURCES.each { |label, path| sources[label] = File.exist?(path) ? SpecCorpus.examples(path) : [] }
      sources["specimen"] = [File.read(MarkdownTypes::SPECIMEN)]
    end
  end

  def survey
    failures = []
    types = {}

    documents.each do |label, examples|
      types[label] = []

      examples.each do |markdown|
        built = begin
          MarkdownTypes.parse_string(markdown, options: MarkdownTypes::DISCOVERY_OPTIONS)
        rescue MarkdownTypes::UnknownType => error
          failures << [label, error.message]
          next
        end

        built.then { |document| collect(document, types[label]) }
      end

      types[label].uniq!
    end

    [types, failures]
  end

  def collect(node, into)
    into << node.type
    node.children.each { |child| collect(child, into) }
  end
end

if __FILE__ == $PROGRAM_NAME
  types, failures = Discover.survey
  every = types.values.flatten.uniq
  generated = MarkdownTypes::BY_TYPE.keys

  puts "examples parsed: #{Discover.documents.transform_values(&:size).inspect}"
  puts
  puts format("%-22s %-24s %-12s %s", "type", "class", "sources", "fields")
  puts "-" * 96

  every.sort_by(&:to_s).each do |type|
    sources = types.filter_map { |label, found| label[0] if found.include?(type) }
    puts format(
      "%-22s %-24s %-12s %s",
      type,
      MarkdownTypes.class_name_for(type),
      sources.join(","),
      MarkdownTypes::TYPES.fetch(type).inspect,
    )
  end

  puts
  puts "#{every.size} types built from #{generated.size} generated classes"
  types.each { |label, found| puts "  #{label}: #{found.size}" }

  unused = generated - every
  puts "generated but unseen: #{unused.inspect}"
  puts "build failures: #{failures.size}"
  failures.first(5).each { |label, message| puts "  #{label}: #{message}" }
  exit 1 unless failures.empty?
end
