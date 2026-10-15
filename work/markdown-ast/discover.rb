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
      SOURCES.each do |label, path|
        sources[label] = File.exist?(path) ? SpecCorpus.examples(path) : []
      end
      sources["specimen"] = [File.read(MarkdownTypes::SPECIMEN)]
    end
  end

  def types_in(source)
    {}.tap do |found|
      source.each do |markdown|
        Commonmarker.parse(markdown, options: MarkdownTypes::DISCOVERY_OPTIONS).walk do |node|
          found[node.type] ||= MarkdownTypes.fields_of(node)
        end
      end
    end
  end

  def survey
    documents.transform_values { |source| types_in(source) }
  end
end

if __FILE__ == $PROGRAM_NAME
  survey = Discover.survey
  every_type = survey.values.flat_map(&:keys).uniq
  fields = survey.values.reduce({}) { |all, types| types.merge(all) }

  puts "examples parsed: #{Discover.documents.transform_values(&:size).inspect}"
  puts "property methods: #{MarkdownTypes::PROPERTY_METHODS.inspect}"
  puts
  puts format("%-22s %-24s %-10s %s", "type", "class", "sources", "properties")
  puts "-" * 104

  every_type.sort_by(&:to_s).each do |type|
    sources = survey.filter_map { |label, types| label if types.key?(type) }
    puts format(
      "%-22s %-24s %-10s %s",
      type,
      MarkdownTypes.class_name_for(type),
      sources.map { |label| label[0] }.join(","),
      fields.fetch(type).inspect,
    )
  end

  puts
  puts "#{every_type.size} types total"
  survey.each { |label, types| puts "  #{label}: #{types.size}" }

  undiscovered = every_type - MarkdownTypes::TYPES.keys
  puts "not pre-registered by the specimen: #{undiscovered.inspect}"
  puts "(those are registered lazily when first built)" unless undiscovered.empty?
end
