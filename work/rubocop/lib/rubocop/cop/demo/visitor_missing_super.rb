require_relative "../../../prism_visitors"

module RuboCop
  module Cop
    module Demo
      class VisitorMissingSuper < Base
        include PrismVisitors

        MSG = "%<name>s does not call super, so the walk stops here."

        def on_new_investigation
          result = Prism.parse(processed_source.raw_source)

          result.value.breadth_first_search_all(&VISITORS).flat_map { |visitor|
            visitor.body.body.filter_map { |statement|
              Hook.new(node: statement, visitor: visitor) if statement.is_a?(Prism::DefNode)
            }
          }.each do |hook|
            case hook
            in Hook(name: HOOK => name, descends: false, from:, to:)
              add_offense(
                Parser::Source::Range.new(processed_source.buffer, from, to),
                message: format(MSG, name: name),
              )
            else
              nil
            end
          end
        end
      end
    end
  end
end
