require "prism"

module RubyComments
  PARTS = /\A(?<marker>\x23+!?[[:blank:]]*)(?<body>.*)\z/m
  BLANK = /\A\x23+[[:blank:]]*\z/
  TAG = /\A\x23+[[:blank:]]*(?<tag>@\w+)/
  DIRECTIVE = /\A\x23+[[:blank:]]*rubocop:(?<mode>disable|enable|todo)\b/
  WRAP = ->(budget) { Regexp.new(format('.{1,%d}(?=\s|\z)|\S+', budget)) }

  PARAGRAPHS = ->(comments) {
    comments.chunk_while { |left, right|
      right.location.start_line == left.location.start_line + 1 &&
        right.location.start_column == left.location.start_column &&
        [left, right].none? { |comment| comment.location.slice.match?(BLANK) } &&
        !right.location.slice.match?(TAG)
    }
  }

  Block = Data.define(:comments, :owner, :budget, :widest, :length, :overrun, :overrun_from, :overrun_to,
                      :line, :end_line, :marker, :indent, :tag, :directive, :wrappable, :wrapped) do
    def initialize(comments:, budget:, owner: nil)
      widest = comments.max_by { |comment| comment.location.slice.length }
      marker = comments.first.location.slice.match(PARTS)[:marker]
      indent = " " * comments.first.location.start_column
      bodies = comments.map { |comment| comment.location.slice.match(PARTS)[:body] }

      super(
        comments: comments,
        owner: owner,
        budget: budget,
        widest: widest,
        length: widest.location.slice.length,
        overrun: widest.location.slice.length - budget,
        overrun_from: widest.location.start_character_offset + budget,
        overrun_to: widest.location.end_character_offset,
        line: comments.first.location.start_line,
        end_line: comments.last.location.start_line,
        marker: marker,
        indent: indent,
        tag: comments.first.location.slice.match(TAG)&.[](:tag)&.to_sym,
        directive: comments.first.location.slice.match(DIRECTIVE)&.[](:mode)&.to_sym,
        wrappable: bodies.join(" ").split(/\s+/).map(&:length).max.to_i <= budget - marker.length,
        wrapped: bodies.join(" ").scan(WRAP.call(budget - marker.length))
                       .map { |line| indent + marker + line.strip }.join("\n"),
      )
    end
  end
end
