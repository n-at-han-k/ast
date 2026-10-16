require "yard"

TARGETS = {
  "refs/decode/lib/decode/index.rb" => "Decode::Index#lookup",
  "refs/yard/lib/yard/registry.rb" => "YARD::Registry.at",
}.freeze

def report(path, target)
  YARD::Registry.clear
  YARD.parse(path)

  objects = YARD::Registry.all
  kinds = objects.group_by { |object| object.type }

  puts path
  puts "  objects:     #{objects.size}"
  puts "  kinds:       #{kinds.transform_values(&:size).sort_by { |_, n| -n }.to_h.inspect}"

  documented = objects.count { |object| !object.docstring.to_s.empty? }
  puts "  documented:  #{documented}/#{objects.size}"

  found = YARD::Registry.at(target)

  if found.nil?
    puts "  #{target}: not found"
    puts
    return
  end

  puts "  #{target}"
  puts "    signature: #{found.signature}" if found.respond_to?(:signature)
  puts "    location:  #{found.line}"
  puts "    visibility: #{found.visibility}"
  puts "    scope:     #{found.scope}" if found.respond_to?(:scope)
  puts "    parameters: #{found.parameters.inspect}" if found.respond_to?(:parameters)
  puts "    docstring: #{found.docstring.to_s.strip[0, 60].inspect}"

  found.tags.each do |tag|
    detail = [tag.name, tag.types&.join("|"), tag.text&.strip&.slice(0, 40)].compact.reject(&:empty?)
    puts "    @#{tag.tag_name} #{detail.join(" ")}"
  end

  puts
end

TARGETS.each { |path, target| report(path, target) if File.exist?(path) }
