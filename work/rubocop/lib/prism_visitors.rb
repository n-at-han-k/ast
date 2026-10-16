require "prism"

module PrismVisitors
  HOOK = /\Avisit_\w+_node\z/
  BASES = [:Visitor, :BasicVisitor, :Compiler].freeze

  VISITORS = ->(node) {
    case node
    in Prism::ClassNode(superclass: Prism::ConstantPathNode(parent: Prism::ConstantReadNode(name: :Prism),
                                                            name: Symbol => base)) if BASES.include?(base)
      true
    else
      false
    end
  }

  Hook = Data.define(:node, :name, :visitor, :base, :descends, :line, :from, :to) do
    def initialize(node:, visitor:)
      super(
        node: node,
        visitor: visitor,
        name: node.name,
        base: visitor.superclass.name,
        descends: !node.breadth_first_search { |child|
          case child
          in Prism::SuperNode | Prism::ForwardingSuperNode then true
          else false
          end
        }.nil?,
        line: node.name_loc.start_line,
        from: node.name_loc.start_character_offset,
        to: node.name_loc.end_character_offset,
      )
    end
  end
end
