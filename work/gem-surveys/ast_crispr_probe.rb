require "ast-crispr"
require "ast-crispr-markdown-markly"

def walk_namespace(mod, depth = 0, seen = {})
  return if depth > 2 || seen[mod]

  seen[mod] = true
  mod.constants.sort.each do |name|
    value = begin
      mod.const_get(name)
    rescue StandardError
      next
    end
    puts "#{"  " * depth}#{mod}::#{name} (#{value.class})"
    if value.is_a?(Class)
      own = (value.instance_methods(false) + value.singleton_methods(false)).sort
      puts "#{"  " * (depth + 1)}methods: #{own.first(14).inspect}" unless own.empty?
    end
    walk_namespace(value, depth + 1, seen) if value.is_a?(Module)
  end
end

puts "Ast::Crispr namespace:"
walk_namespace(Ast::Crispr)

puts
puts "Ast::Crispr module methods: #{Ast::Crispr.methods(false).sort.inspect}"

puts
puts "gems that define an Ast::Crispr backend:"
$LOADED_FEATURES.grep(/crispr|tree_haver|ast-merge/).each { |path| puts "  #{path}" }
