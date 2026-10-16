require "prism"

class MethodLister < Prism::Visitor
  def initialize
    @scope = []
    @methods = []
  end

  attr_reader :methods

  def visit_class_node(node)
    @scope.push(node.constant_path.slice)
    super
    @scope.pop
  end

  def visit_module_node(node)
    @scope.push(node.constant_path.slice)
    @scope.pop
  end

  def visit_def_node(node)
    @methods << [@scope.join("::"), node.name].join("#")
  end
end

class Counter < Prism::Visitor
  def initialize
    @calls = 0
  end

  attr_reader :calls

  def visit_call_node(node)
    @calls += 1
    super
  end
end
