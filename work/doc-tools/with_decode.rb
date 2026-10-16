require "decode/index"

TARGETS = {
  "refs/decode/lib/decode/index.rb" => "Decode::Index#lookup",
  "refs/yard/lib/yard/registry.rb" => "YARD::Registry::class#at",
}.freeze

def report(path, target)
  index = Decode::Index.new
  index.update([path])

  kinds = index.definitions.values.group_by { |definition| definition.class.name.split("::").last }
  found = index.definitions.values.find { |definition| definition.qualified_name == target }

  puts path
  puts "  definitions: #{index.definitions.size}"
  puts "  kinds:       #{kinds.transform_values(&:size).sort_by { |_, n| -n }.to_h.inspect}"

  relevant = index.definitions.values.select(&:coverage_relevant?)
  documented = relevant.count(&:documented?)
  puts "  documented:  #{documented}/#{relevant.size} coverage-relevant"

  if found.nil?
    puts "  #{target}: not found"
    puts
    return
  end

  puts "  #{target}"
  puts "    form:      #{found.long_form}"
  puts "    location:  #{found.location&.line}"
  puts "    documented: #{found.documented?}"

  documentation = found.documentation
  if documentation
    documentation.children.each do |child|
      case child
      when Decode::Comment::Parameter
        puts "    @parameter #{child.name} [#{child.type}]"
      when Decode::Comment::Returns
        puts "    @returns   [#{child.type}]"
      when Decode::Comment::Raises
        puts "    @raises    [#{child.type}]"
      when Decode::Comment::Text
        puts "    text:      #{child.line.to_s.strip[0, 60].inspect}"
      else
        puts "    #{child.class.name.split("::").last.downcase}"
      end
    end
  end

  puts
end

TARGETS.each { |path, target| report(path, target) if File.exist?(path) }
