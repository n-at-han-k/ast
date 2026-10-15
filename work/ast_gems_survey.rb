GEMS = {
  "prism" => %w[Prism::Node Prism::DefNode Prism::CallNode Prism::ProgramNode],
  "ast" => %w[AST::Node],
  "rubocop-ast" => %w[RuboCop::AST::Node RuboCop::AST::SendNode RuboCop::AST::NodePattern],
  "parser/current" => %w[Parser::AST::Node],
  "commonmarker" => %w[Commonmarker::Node],
  "markly" => %w[Markly::Node],
  "psych" => %w[Psych::Nodes::Node Psych::Nodes::Document],
  "rbs" => %w[RBS::AST::Declarations::Class RBS::Types::ClassInstance],
  "tree_haver" => %w[TreeHaver::Node TreeHaver::Tree],
  "yard" => %w[YARD::CodeObjects::Base],
  "rdoc" => %w[RDoc::AnyMethod],
}.freeze

HOOKS = %i[deconstruct deconstruct_keys].freeze

def constant(name)
  name.split("::").inject(Object) { |scope, part| scope.const_get(part) }
rescue NameError, TypeError
  nil
end

def hook_owner(klass, hook)
  klass.instance_method(hook).owner.to_s
rescue NameError
  nil
end

def safely
  yield
rescue StandardError, NoMatchingPatternError => error
  error.class.to_s
end

rows = []

GEMS.each do |requirement, names|
  begin
    require requirement
  rescue LoadError => error
    rows << [requirement, "LoadError", error.message[0, 36], ""]
    next
  end

  names.each do |name|
    klass = constant(name)
    next unless klass.is_a?(Class)

    rows << [requirement, name, *HOOKS.map { |hook| hook_owner(klass, hook) || "-" }]
  end
end

puts format("%-18s %-40s %-26s %s", "gem", "class", "deconstruct", "deconstruct_keys")
puts "-" * 120
rows.each { |row| puts format("%-18s %-40s %-26s %s", *row) }

if constant("Prism")
  node = Prism.parse("def greet(name) = name").value.statements.body.first
  keys = node.deconstruct_keys(nil).keys
  nested = case node
           in Prism::DefNode(name:, parameters: Prism::ParametersNode(requireds: [Prism::RequiredParameterNode(name: param)]))
             "matched: def #{name} with one required parameter #{param}"
           else
             "no match"
           end
  field = (node in Prism::DefNode(name: :greet))
  array = safely { node.deconstruct.map { |value| value.class.name }.inspect }

  puts
  puts "Prism as the reference"
  puts "  node class:      #{node.class}"
  puts "  deconstruct_keys #{keys.inspect}"
  puts "  nested pattern:  #{nested}"
  puts "  field pattern:   #{field}"
  puts "  deconstruct:     #{array}"
end

if constant("AST::Node")
  sexp = AST::Node.new(:heading, ["Title", 2])
  as_array = sexp.deconstruct.inspect
  sexp_match = (sexp in [:heading, *])
  hash_match = safely { sexp in { type: :heading } }

  puts
  puts "AST::Node for comparison"
  puts "  deconstruct:     #{as_array}"
  puts "  sexp pattern:    #{sexp_match}"
  puts "  hash pattern:    #{hash_match}"
end
