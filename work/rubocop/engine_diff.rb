require "rubocop"
require "prism"

SOURCE = <<~CODE
  class Greeting
    DEFAULT = "there"

    def greet(name = DEFAULT)
      "hello, " + name.to_s
    end
  end
CODE

VERSION = 3.4

def tree(engine)
  RuboCop::ProcessedSource.new(SOURCE, VERSION, nil, parser_engine: engine).ast
end

whitequark = tree(:parser_whitequark)
prism = tree(:parser_prism)

puts "parser_whitequark"
puts whitequark.to_s
puts

puts "parser_prism"
puts prism.to_s
puts

puts "identical: #{whitequark.to_s == prism.to_s}"
puts "node classes: #{[whitequark.class, prism.class].uniq.join(", ")}"
puts

puts "prism's own tree"
Prism.parse(SOURCE).value.breadth_first_search { |node| puts "  " + node.class.name; false }
