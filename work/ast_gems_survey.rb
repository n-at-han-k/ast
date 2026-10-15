CANDIDATES = {
  "ast" => %w[AST::Node AST::Sexp AST::Processor],
  "rubocop-ast" => %w[RuboCop::AST::Node RuboCop::AST::NodePattern],
  "ast-crispr" => %w[AstCrispr ASTCrispr Ast::Crispr],
  "ast-crispr-markdown-markly" => %w[AstCrispr::Markdown AstCrispr::Markdown::Markly],
  "tree_haver" => %w[TreeHaver],
  "markly" => %w[Markly Markly::Node],
}.freeze

PATTERN_METHODS = %i[deconstruct deconstruct_keys].freeze

def constant(name)
  name.split("::").inject(Object) { |scope, part| scope.const_get(part) }
rescue NameError
  nil
end

def describe(klass)
  PATTERN_METHODS.map do |method|
    owner = begin
      klass.instance_method(method).owner
    rescue NameError
      nil
    end
    "#{method}=#{owner ? owner : "no"}"
  end.join(" ")
end

CANDIDATES.each do |gem_name, constants|
  loaded = begin
    require gem_name
    "loaded"
  rescue LoadError => error
    "LoadError: #{error.message[0, 60]}"
  end

  puts "#{gem_name}: #{loaded}"

  constants.each do |name|
    constant(name).then do |found|
      next unless found

      puts "  #{name} (#{found.class})"
      puts "    #{describe(found)}" if found.is_a?(Class)
    end
  end
  puts
end

if constant("AST::Node")
  puts "AST::Node public instance methods:"
  puts "  #{(AST::Node.instance_methods - Object.instance_methods).sort.inspect}"

  puts
  puts "AST::Node deconstruct semantics:"
  node = AST::Node.new(:heading, ["Title", 2])
  puts "  node.type              #{node.type.inspect}"
  puts "  node.children          #{node.children.inspect}"
  puts "  node.to_a              #{node.to_a.inspect}"
  puts "  node.deconstruct       #{node.deconstruct.inspect}"
  puts "  node.to_sexp           #{node.to_sexp.inspect}"
  puts "  deconstruct is to_a?   #{AST::Node.instance_method(:deconstruct) == AST::Node.instance_method(:to_a)}"

  matched = case node
            in [String => text, Integer => level] then "children pattern: #{text} / #{level}"
            else "no match"
            end
  puts "  array pattern          #{matched}"

  puts "  sexp-style [:heading, ...] matches: #{node in [:heading, *]}"
end
