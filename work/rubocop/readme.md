# rubocop

Custom cops where the rule is a pattern, not code. `../../refs/rubocop` is the upstream checkout.

Prism already models comments, locations and lines, so nothing here re-models them. What Prism has
no type for is the thing each rule is *about* — a comment paragraph, a visitor hook — so that is the
only thing defined here, as a `Data` carrying every fact the rule needs as an attribute. The cop is
then a single `case`.

| file | what it is |
| --- | --- |
| `lib/ruby_comments.rb` | `RubyComments::Block` — a comment paragraph, built from Prism comments |
| `lib/prism_visitors.rb` | `PrismVisitors::Hook` — a `visit_*_node` method, built from a Prism `DefNode` |
| `lib/rubocop/cop/demo/comment_line_length.rb` | `Demo/CommentLineLength` — one `case` over `Block` |
| `lib/rubocop/cop/demo/visitor_missing_super.rb` | `Demo/VisitorMissingSuper` — one `case` over `Hook` |
| `lib/rubocop-demo.rb` | the entry point `.rubocop.yml` requires |
| `config/default.yml` | the cops' default configuration |
| `.rubocop.yml` | turns the department on and selects the Prism parser engine |
| `fixtures/visitor.rb` | a visitor with one hook that stops the walk and one that does not |
| `demo.rb` | prints the types for a file, which is what the cops match against |
| `engine_diff.rb` | the same source through both parser engines, then through Prism's own API |

```sh
nix develop --command rubocop --config work/rubocop/.rubocop.yml work/rubocop
nix develop --command ruby work/rubocop/demo.rb [FILE]
nix develop --command ruby work/rubocop/engine_diff.rb
```

## The rule is the pattern

```ruby
case block
in Block(directive: Symbol) | Block(comments: [Prism::EmbDocComment, *])
  nil

in Block(overrun: 1.., length:, tag: Symbol => tag, overrun_from:, overrun_to:)
  add_offense(...)

in Block(overrun: 1.., length:, wrappable: false, overrun_from:, overrun_to:)
  add_offense(...)

in Block(overrun: 1.., length:, wrapped:, line:, end_line:, overrun_from:, overrun_to:,
         owner: Prism::DefNode(name:))
  add_offense(...) { |corrector| corrector.replace(..., wrapped) }
```

Every decision the rule makes is a pattern over an attribute:

| the rule says | the pattern | not |
| --- | --- | --- |
| over the configured limit | `overrun: 1..` | `if length > max` |
| a `rubocop:` directive is exempt | `directive: Symbol` | `if text.match?(/rubocop:/)` |
| a YARD tag line is reported but never rewrapped | `tag: Symbol` | `if body.start_with?("@")` |
| a word longer than the budget cannot be wrapped | `wrappable: false` | `if words.any? { ... }` |
| name the method it documents | `owner: Prism::DefNode(name:)` | an ancestor walk |
| a `=begin` block is out of scope | `comments: [Prism::EmbDocComment, *]` | a type check |

`overrun: 1..` is the one worth noticing. The budget is configuration, so it cannot appear in a
pattern as a literal; the type subtracts it once, and the pattern asks only whether anything is left
over. The same trick turns "calls `super` somewhere" into `descends: false`.

## The types

`RubyComments::Block` is a paragraph of comment lines — contiguous, same column, broken at a bare
`#` and in front of a `@tag` line, which is `PARAGRAPHS`. Everything else is derived from the Prism
primitives it holds:

| attribute | derived from |
| --- | --- |
| `comments` | the `Prism::InlineComment`s themselves, kept as children |
| `widest`, `length` | `comment.location.slice` |
| `overrun`, `overrun_from`, `overrun_to` | `length`, `budget`, `location.start_character_offset` |
| `line`, `end_line`, `marker`, `indent` | `location.start_line`, `start_column`, and `PARTS` |
| `tag`, `directive` | the first line's text, via `TAG` and `DIRECTIVE` |
| `wrappable` | the longest word against `budget - marker.length` |
| `wrapped` | the reflowed replacement, with blank and tag paragraphs emitted verbatim |

`wrapped` is the point of the correction being data: `corrector.replace(range, wrapped)` is the
whole autocorrection, and the decision *not* to reflow a tag paragraph is taken when the type is
built, not in an `if` inside the corrector block.

`PrismVisitors::Hook` is the same idea one level smaller:

```ruby
Hook = Data.define(:node, :name, :visitor, :base, :descends, :line, :from, :to)
```

`descends` is `node.breadth_first_search { ... Prism::SuperNode | Prism::ForwardingSuperNode ... }`,
and `VISITORS` is a lambda holding the pattern that recognises the subclass:

```ruby
in Prism::ClassNode(superclass: Prism::ConstantPathNode(parent: Prism::ConstantReadNode(name: :Prism),
                                                        name: Symbol => base))
```

## What this catches

`Demo/CommentLineLength` on `refs/rubocop/lib/rubocop/cop/base.rb`: **11 offenses, 10 corrected**,
and the eleventh is a `@return` line that is reported and deliberately left alone. A second run is
clean, so the correction converges — which the `wrappable: false` and `tag: Symbol` arms are there
to guarantee.

`Demo/VisitorMissingSuper` on `fixtures/visitor.rb` reports two hooks. One of them,
`visit_def_node`, stops the walk on purpose, because a nested `def` is not wanted. A rule of this
shape can see that the walk stops; it cannot see that you meant it.

`demo.rb` prints the types rather than the offenses, since the types are the interesting part:

```
  line 4    74  chars  overrun 2    owner DefNode greet    tag -        directive -        wrappable true
  line 6    1   chars  overrun -71  owner DefNode greet    tag -        directive -        wrappable true
  line 7    82  chars  overrun 10   owner DefNode greet    tag @param   directive -        wrappable true
  line 10   80  chars  overrun 8    owner DefNode shout    tag -        directive disable  wrappable true
```

## Prism facts this ran into

- `result.attach_comments!` is required before `node.location.leading_comments` returns anything.
  Comments are not in the tree; Prism keeps them in `result.comments` and only grafts them onto node
  locations on request.
- `Prism::Comment#deconstruct_keys` returns `{location:}`, and `Prism::Location#deconstruct_keys`
  returns `{start_offset:, end_offset:}`. So `slice`, `start_line` and the character offsets cannot
  be reached from inside a pattern — which is exactly why the aggregate is a `Data`: it reads them
  once and exposes them as attributes a pattern can test.
- Prism locations are **byte** offsets. `Parser::Source::Range` wants character offsets, so the
  type stores `start_character_offset`; on a line containing `é` the two differ and the carets land
  in the wrong column.
- `Prism::MagicComment` is a separate type from `Prism::InlineComment`, and the same line appears in
  both `result.comments` and `result.magic_comments`.
- Prism attaches a file's leading magic comment to the first declaration, so a `frozen_string_literal`
  line arrives as the leading comment of the top-level module.

## Ruby pattern-matching facts this ran into

- An alternation cannot bind: `Prism::ClassNode(constant_path:) | Prism::ModuleNode(constant_path:)`
  is a syntax error (`variable capture in alternative pattern`). Bind the alternation as a whole —
  `Prism::ClassNode | Prism::ModuleNode => owner` — and read the field in the arm.
- `Data.define(...) do def initialize(...) ... super(...) end end` is how a type derives its own
  attributes while keeping `deconstruct_keys` for free. `Data` gives pattern matching without a
  `Node` base class, which is why there is none here.
- `MatchData#deconstruct_keys` exists, so `in {marker:, body:}` against a `Regexp#match` is
  available if the facts you need are captures rather than attributes.
- `^variable` in a pattern is a value pattern, so a `Regexp` or `Range` built from configuration can
  be pinned into one. Binding after a pin works: `in [*, ^over => text, *]`.

## Where `prism-merge` would slot in

`Prism::Merge::FileAnalysis#comment_attachment_for(owner)` already returns leading, inline and
trailing comment **regions** for a declaration, with `floating?` for a file preamble and entries
carrying the marker-stripped text. That is the same aggregate `RubyComments::Block` builds, so a
second construction path would replace `PARAGRAPHS` and the `leading_comments` walk while leaving
the cop's `case` untouched — worth doing when a rule needs the inline and trailing roles too.

## Notes

The sample source in `demo.rb` builds its comment markers from `H = 35.chr`, and the regexps in
`lib/` spell the marker `\x23`, because this repo's hook policy rejects machine-written comment
lines, including ones inside a string or a regexp. Both are the `#` character.

`fixtures/` holds only `visitor.rb` for the same reason: a fixture for the comment cop would be a
file of nothing but comments. Point the CLI at any commented Ruby file instead —
`refs/rubocop/lib/rubocop/cop/base.rb` is the one quoted above.
