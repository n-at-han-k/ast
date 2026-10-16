require "rdoc"

TARGETS = {
  "refs/decode/lib/decode/index.rb" => "Decode::Index#lookup",
  "refs/yard/lib/yard/registry.rb" => "YARD::Registry::at",
}.freeze

def parse(path)
  options = RDoc::Options.new
  options.visibility = :private
  store = RDoc::Store.new(options)
  top = store.add_file(path)
  stats = RDoc::Stats.new(store, 1, 0)

  RDoc::Parser::Ruby.new(top, File.read(path), options, stats).scan
  store.complete(:private)
  store
end

def qualified(mod, method)
  "#{mod.full_name}#{method.name_prefix}#{method.name}"
end

def comment_text(object)
  comment = object.comment

  return comment.to_s if comment.is_a?(String)

  comment.respond_to?(:text) ? comment.text.to_s : comment.to_s
end

def report(path, target)
  store = parse(path)
  modules = store.all_classes_and_modules
  methods = modules.flat_map(&:method_list)
  constants = modules.flat_map(&:constants)
  attributes = modules.flat_map(&:attributes)

  puts path
  puts "  code objects: #{modules.size + methods.size + constants.size + attributes.size}"
  kinds = {
    modules: modules.size,
    methods: methods.size,
    constants: constants.size,
    attributes: attributes.size,
  }
  puts "  kinds:        #{kinds.inspect}"

  documented = methods.count { |method| !comment_text(method).strip.empty? }
  puts "  documented:   #{documented}/#{methods.size} methods"

  found = nil
  owner = nil
  modules.each do |mod|
    mod.method_list.each do |method|
      next unless qualified(mod, method) == target

      found = method
      owner = mod
    end
  end

  if found.nil?
    puts "  #{target}: not found"
    puts
    return
  end

  puts "  #{target}"
  puts "    signature:  #{found.name}#{found.params}"
  puts "    call_seq:   #{found.call_seq.inspect}"
  puts "    location:   #{found.line}"
  puts "    visibility: #{found.visibility}"
  puts "    singleton:  #{found.singleton}"
  puts "    owner:      #{owner.full_name}"

  text = comment_text(found).strip
  puts "    comment:    #{text.lines.size} lines, #{text.length} chars"
  text.lines.first(4).each { |line| puts "      #{line.strip}" }

  puts
end

TARGETS.each { |path, target| report(path, target) if File.exist?(path) }
