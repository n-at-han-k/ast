# work

Scratch space for experiments. The read-only upstream checkouts live in `../refs`.

| script | does |
| --- | --- |
| `prism_example.rb` | lists the methods a Ruby file defines, via Prism |
| `md_nodes.rb` | shared commonmarker traversal used by the Markdown scripts |
| `md_ast.rb` | `AST::Node` subclasses (`Rule`, `Fenced`, `Reasoning`, …) built from the commonmarker tree |
| `ast_gems_survey.rb` | what the AST gems in the bundle provide, and their pattern-matching support |
| `ast_crispr_probe.rb` | walks the `Ast::Crispr` namespace |
| `md_validate.rb` | validates documents with one `case`/`in` statement (`--strict` to exit non-zero) |
| `markdown_ast.rb` | dumps a Markdown AST (`--outline`, `--counts`) |
| `md_shape.rb` | prints the block shape of each section — how the schema below was derived |
| `fix_mojibake.rb` | reverses double-encoded UTF-8 (`--write` to apply) |

## The rule/example/reasoning schema

`md_shape.rb` prints one line per section showing its blocks in order, which is how the schema was
read off the document rather than guessed:

```
h2 (line 66) 2. Append Order Rule
    para[**Append widgets from INSIDE the parent's tap block, not before it.**] code[ruby] code[ruby] para[**Rationale:**] thematic_break
```

Across all 17 numbered sections of `style-rules.md` the pattern is:

| part | block | identified by |
| --- | --- | --- |
| **rule** | first block of the section | a paragraph opening with `**bold**` — an imperative directive |
| **example** | next | one or more fenced code blocks, usually a `WRONG`/`RIGHT` pair |
| **reasoning** | last | a paragraph opening with a bold `**Label:**`, sometimes followed by a list |
| terminator | — | a thematic break |

Position is what separates rule from reasoning, not wording. Both are bold-led paragraphs, and both
sometimes end in a colon, so a text heuristic cannot tell them apart; the rule is simply the section's
first block. The reasoning label is `Rationale:` in 10 of 17 sections and otherwise varies —
`When to use:`, `Key points:`, `Pattern elements:`, `Anti-pattern:`, `Implementations:`,
`Store methods:`, `The pattern:`, `To trigger filter update:` — so the check requires a bold label,
not a specific word.

## Validating with pattern matching

`md_ast.rb` builds the document out of real `AST::Node` subclasses (the `ast` gem, already in the
bundle via `parser`). One class per block kind — `Rule`, `Fenced`, `Indented`, `Reasoning`, `Prose`,
`Items`, `Break`, `Table` — grouped into a `Section`, each with its own `deconstruct_keys`. The
whole schema is then one `case` in `md_validate.rb`:

```ruby
case section
in { examples: [*, Indented => block, *] }
  [:indented_example, "the code block on line #{block.line} is indented, so it carries no language"]

in { rule: Rule, examples: [Fenced, *], reasoning: [Reasoning, *], terminated: true }
  [:ok, "rule, example and reasoning all present"]

in { rule: Rule, examples: [Fenced, *], reasoning: [Reasoning, *] }
  [:no_terminator, "does not end with a thematic break"]

in { rule: Rule, examples: [Fenced, *] }
  [:no_reasoning, "nothing states why the rule holds"]

in { rule: Rule(text:) }
  [:no_example, "#{text[0, 40].inspect} is asserted with no example"]

in { blocks: [opening, *] }
  [:no_rule, "the section opens with #{opening.type}, so no bold directive states the rule"]

in { heading: }
  [:empty, "#{heading.inspect} has no body"]
end
```

Three things make this read as patterns rather than as conditions in disguise:

- **A class per kind, so the arms name types.** A fenced block and an indented one are `Fenced` and
  `Indented`, not one `Example` carrying a `lang` that might be nil.
- **Key presence carries the meaning.** `Section#deconstruct_keys` omits `rule:` when there is no
  rule and omits `terminated:` unless the section ends in a break, so the arms test for a key rather
  than compare against `nil`. `Fenced#deconstruct_keys` is a superset of `Indented`'s — it adds
  `lang:` — which is the same trick.
- **Failures are arms, not checks.** Every outcome, including the empty section, is a branch of the
  one `case`, so there is no fallthrough and no guard clause.

Patterns are ordered most specific first, which is load-bearing: `indented_example` precedes the
conforming arm so an indented block is reported wherever it sits, and a section with several faults
reports the first arm that matches.

Two Ruby constraints also shape it. A pattern cannot live in a constant — `*` is invalid in a hash
literal and `^` pins expressions, not constants — so patterns are written inline. And an array
pattern allows one splat, so `[Rule, *, Fenced, *, Reasoning]` does not parse; gaps go in a find
pattern (`[*, x, *]`) or into derived `Section` keys that each get their own pattern.

Because the nodes are genuine `AST::Node`s, `to_sexp` comes for free — `--sexp` prints the tree, and
it is what caught three bugs the table hid: a reasoning label classified as the rule in a section
that has no rule, softbreaks dropped so two lines ran together (`cannot beextracted`), and reasoning
text repeating its own label.

```
(section
  (rule "Chain the list models in a fixed order.")
  (indented "ListStore -> FilterListModel -> SortListModel -> SingleSelection\n")
  (reasoning "Rationale" "The diagram is indented rather than fenced, so it carries no language…")
  (break))
```

### Fixtures

`fixtures/correct.md` and `fixtures/incorrect.md` exercise the branches in both directions; the
incorrect one breaks the schema in exactly one way per section.

```sh
ruby work/md_validate.rb work/fixtures/correct.md work/fixtures/incorrect.md
```

```
work/fixtures/correct.md: 3 rule section(s)
  ok   1. Memoize Widgets           ok                 rule, example and reasoning all present
  ok   2. Prefer tap Over Locals    ok                 rule, example and reasoning all present
  ok   3. One Expression Per Method ok                 rule, example and reasoning all present
  3/3 conform

work/fixtures/incorrect.md: 5 rule section(s)
  FAIL 1. Missing Rule              no_rule            section opens with example, not a bold directive
  FAIL 2. Missing Example           no_example         no code block
  FAIL 3. Unfenced Example          unfenced_example   code block on line 33 has no language
  FAIL 4. Missing Reasoning         no_reasoning       no bold-labelled block after the rule
  FAIL 5. Missing Terminator        no_terminator      does not end with a thematic break
  0/5 conform
```

An h2 titled `N. Name` is treated as a rule section; the title, table of contents and summary table
are skipped. Run against the real document, **14 of 17 sections conform**:

```
FAIL 12. Incremental Development Rule  no_example         "Never remove working functionality when " is asserted with no example
FAIL 14. ListModel Chain Pattern       indented_example   the code block on line 435 is indented, so it carries no language
FAIL 16. Delete with Undo Pattern      no_rule            the section opens with fenced, so no bold directive states the rule
```

### Which AST gems were available

`ast_gems_survey.rb` records why the `ast` gem is the one used here. `AST::Node` implements
`deconstruct` as `[type, *children]`, so s-expression array patterns like `node in [:rule, *]` work
without any help, though it has no `deconstruct_keys` — hence the subclasses above. `Markly::Node`
and `Commonmarker::Node` implement neither. `ast-crispr` is not a node library at all: it is a
surgical-edit contract (`read_ast`, `structural_owners`, `structure_profile`) with a markly-backed
markdown adapter, so it belongs to a later experiment about *editing* these documents rather than
validating them.

Those three are genuine gaps in the reference document: §12 argues by numbered list with no code, §14
opens with an indented ASCII diagram rather than a fenced block, and §16 jumps straight into code
with no rule statement at all. Worth fixing upstream before this schema is enforced elsewhere.

## markdown_ast.rb

Parses a Markdown file into an AST. `commonmarker` 2.x is a binding for comrak, a CommonMark
parser, and it came into the bundle as a dependency of `commonmarker-merge`.

```sh
nix develop --command ruby work/markdown_ast.rb work/style-rules.md            # full tree
nix develop --command ruby work/markdown_ast.rb work/style-rules.md --outline  # headings only
nix develop --command ruby work/markdown_ast.rb work/style-rules.md --counts   # node tally
```

`work/style-rules.md` is the Ruby GTK4 style rules from `ruby-gtk-project/port-scaffold`, with the
upstream double-encoding repaired by `fix_mojibake.rb`. It parses to 458 nodes:

```
  text            147      code_block       29
  paragraph        77      code             22
  item             38      heading          20
  strong           34      thematic_break   19
  table_cell       33      link             17
```

28 of the 29 code blocks are fenced `ruby`, which makes this file a natural bridge between the two
scripts: the Markdown AST locates the Ruby, and Prism can parse what it finds.

Two things the script exists to demonstrate:

- `Commonmarker::Node#walk` yields every node but carries no depth, so the tree shape is lost.
  Traversing `first_child` / `next_sibling` by hand is what makes indentation (and therefore the
  structure) visible.
- `node.string_content` raises for container nodes rather than returning nil, so every read of it
  needs a guard. `source_position` works on every node, including `document`.

Extensions are not on by default. Without `extension: { table: true }` the summary table at the end
of the document parses as paragraphs of pipe characters instead of `table` / `table_row` /
`table_cell`.

## prism_example.rb

Lists the methods defined in a Ruby file: enclosing scope, `#` for instance and `.` for singleton
methods, parameter source text, line number, and the doc comment.

```sh
ruby work/prism_example.rb work/sample.rb
```

```
work/sample.rb: 5 method(s)
  Greeting::Formal#initialize(title) line 5
  Greeting::Formal#greet(name = DEFAULT) line 9
  Greeting::Formal.build(title)      line 13
  Greeting::Casual#greet(name = DEFAULT) line 19
  (top level)#shout(text)            line 23
```

Prism ships with Ruby 3.4, so this needs no bundle and no gems.

Two things the example exists to demonstrate:

- `Prism::Visitor` subclasses get a `visit_*_node` hook per node type. Calling `super` continues the
  walk into children, which is how the class/module scope stack stays in sync with the traversal.
- `node.location.leading_comments` is **empty** until `result.attach_comments!` is called. Comments
  are not part of the tree; Prism keeps them in `result.comments` and only grafts them onto node
  locations on request.

The doc column prints blank for `work/sample.rb` because that fixture carries no comments — the
repo's hook policy blocks machine-written comments, so a commented fixture needs to be added by
hand. To see the column populated, point the script at any commented Ruby file, e.g.
`ruby work/prism_example.rb refs/yard/lib/yard.rb`.

## Running against the submodule instead of stdlib

`ruby -Irefs/prism/lib` does **not** work on a fresh checkout: `lib/prism/node.rb` is generated from
templates and the C extension is unbuilt, so the require fails with
`cannot load such file -- .../lib/prism/node`. Build it first:

```sh
cd refs/prism && bundle install && bundle exec rake templates compile
```
