require_relative "../../../ruby_comments"

module RuboCop
  module Cop
    module Demo
      class CommentLineLength < Base
        extend AutoCorrector

        include RubyComments

        MSG_METHOD = "The doc comment on #%<owner>s is %<length>d characters; keep it to %<max>d."
        MSG_CONSTANT = "The doc comment on %<owner>s is %<length>d characters; keep it to %<max>d."
        MSG_TAGGED = "The %<tag>s line is %<length>d characters; keep it to %<max>d."
        MSG_UNWRAPPABLE = "Comment is %<length>d characters and holds a word too long to wrap."
        MSG_UNOWNED = "Comment is %<length>d characters; keep it to %<max>d."

        def on_new_investigation
          budget = cop_config.fetch("Max", 72)
          result = Prism.parse(processed_source.raw_source)
          result.attach_comments!

          documented = result.value.breadth_first_search_all { |node| node.location.leading_comments.any? }
          attached = documented.flat_map { |owner| owner.location.leading_comments }

          documented.flat_map { |owner|
            PARAGRAPHS.call(owner.location.leading_comments)
                      .map { |run| Block.new(comments: run, owner: owner, budget: budget) }
          }.concat(
            PARAGRAPHS.call(result.comments - attached).map { |run| Block.new(comments: run, budget: budget) },
          ).each do |block|
            case block
            in Block(directive: Symbol) | Block(comments: [Prism::EmbDocComment, *])
              nil

            in Block(overrun: 1.., length:, tag: Symbol => tag, overrun_from:, overrun_to:)
              add_offense(
                Parser::Source::Range.new(processed_source.buffer, overrun_from, overrun_to),
                message: format(MSG_TAGGED, tag: tag, length: length, max: budget),
              )

            in Block(overrun: 1.., length:, wrappable: false, overrun_from:, overrun_to:)
              add_offense(
                Parser::Source::Range.new(processed_source.buffer, overrun_from, overrun_to),
                message: format(MSG_UNWRAPPABLE, length: length),
              )

            in Block(overrun: 1.., length:, wrapped:, line:, end_line:, overrun_from:, overrun_to:,
                     owner: Prism::DefNode(name:))
              add_offense(
                Parser::Source::Range.new(processed_source.buffer, overrun_from, overrun_to),
                message: format(MSG_METHOD, owner: name, length: length, max: budget),
              ) do |corrector|
                corrector.replace(
                  processed_source.buffer.line_range(line).join(processed_source.buffer.line_range(end_line)),
                  wrapped,
                )
              end

            in Block(overrun: 1.., length:, wrapped:, line:, end_line:, overrun_from:, overrun_to:,
                     owner: Prism::ClassNode | Prism::ModuleNode => owner)
              add_offense(
                Parser::Source::Range.new(processed_source.buffer, overrun_from, overrun_to),
                message: format(MSG_CONSTANT, owner: owner.constant_path.slice, length: length, max: budget),
              ) do |corrector|
                corrector.replace(
                  processed_source.buffer.line_range(line).join(processed_source.buffer.line_range(end_line)),
                  wrapped,
                )
              end

            in Block(overrun: 1.., length:, wrapped:, line:, end_line:, overrun_from:, overrun_to:)
              add_offense(
                Parser::Source::Range.new(processed_source.buffer, overrun_from, overrun_to),
                message: format(MSG_UNOWNED, length: length, max: budget),
              ) do |corrector|
                corrector.replace(
                  processed_source.buffer.line_range(line).join(processed_source.buffer.line_range(end_line)),
                  wrapped,
                )
              end

            else
              nil
            end
          end
        end
      end
    end
  end
end
