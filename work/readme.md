# work

Scratch space for experiments. The read-only upstream checkouts live in `../refs`.

| script | does |
| --- | --- |
| `prism_example.rb` | lists the methods a Ruby file defines, via Prism |
| `md_nodes.rb` | shared commonmarker traversal used by the Markdown scripts |
| `markdown_types.rb` | base markdown node types — one class per kind, Prism-style, with `deconstruct_keys` |
| `markdown_types_demo.rb` | prints the typed tree and matches composed patterns over it |
| `md_rules.rb` | parses via TreeHaver and classifies blocks into `Ast::Merge::SectionTyping::TypedSection`s |
| `treehaver_parse.rb` | what TreeHaver returns for a markdown file, and which pattern hooks the nodes have |
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

## Base markdown node types

No markdown parser in the bundle has a class per node kind — each backend has one generic `Node`
whose kind is a string, so `in Heading(level: 2)` cannot be written against it. `markdown_types.rb`
supplies those types the way Prism does: one class per kind, generated from a single table, each
carrying `deconstruct_keys` (named fields), `deconstruct` (positional children) and `line`.

22 types cover CommonMark plus the GFM table extension:

```
Document Heading Paragraph CodeBlock HtmlBlock BlockQuote List ListItem ThematicBreak
Table TableRow TableCell FootnoteDefinition
Text Code Emph Strong Link Image SoftBreak LineBreak HtmlInline
```

Fields are only where a kind needs them — `Heading(level:)`, `CodeBlock(lang:, code:)`,
`List(ordered:, tight:)`, `Link(url:, title:)`, `Text(content:)` — so the tree reads as data:

```
Document()
  Heading(level: 1) line=1
    Text(content: "Example Rules — Conforming") line=1
  List(ordered: true, tight: true) line=9
    ListItem() line=9
      Paragraph() line=9
        Link(url: "#1-memoize-widgets", title: nil) line=9
```

Parsing goes through TreeHaver, and kinds are mapped with
`Markdown::Merge::NodeTypeNormalizer.canonical_type`, so the type table is keyed on canonical
markdown types rather than one backend's spelling. Anything unmapped becomes `Unknown(original:)`;
the 613-line `style-rules.md` produces none.

Composition is then the caller's business, which is the point of having base types:

```ruby
case node
in Heading(level: 2, children: [Text(content:)])        then "section #{content.inspect}"
in Paragraph(children: [Strong => strong, *])           then "bold-led #{strong.text.inspect}"
in CodeBlock(lang: String => lang)                      then "fenced #{lang} block"
in CodeBlock(lang: nil)                                 then "indented block"
in List(ordered: true, children:)                       then "ordered list of #{children.size}"
end
```

`Strong(children: [Text(content:)])` deliberately does not match `**memoize with `||=`**`, whose
children are `[Text, Code, Text]`. `Node#text` joins the inline children when the exact shape does
not matter.

## Validating with pattern matching

The types come from `ast-merge`, not from here. `Ast::Merge::SectionTyping` already provides what
this needs:

- `TypedSection = Struct.new(:type, :name, :node, :metadata, keyword_init: true)` — a Struct, so it
  supports `deconstruct_keys` natively and goes straight into a `case`.
- `CallableClassifier.new(lambda)` — a classifier without a subclass. The gem's own example writes a
  lambda that walks `node.arguments` to pull out a block name, which is exactly how `md_rules.rb`
  walks `next_sibling` to collect a heading's body.
- `classify_all(children)` — classifies a node list, buffering consecutive unclassified nodes into
  `:unclassified` sections, which `unclassified?` then skips (the title, table of contents and
  summary table).

`md_rules.rb` parses through TreeHaver with the commonmarker backend and classifies each heading
matching `N. Name` into a `TypedSection`, with the body blocks typed by role — `:rule`,
`:example`, `:indented_example`, `:reasoning`, `:terminator`, `:prose`, `:items` — in its metadata.
Block types come from `Markdown::Merge::MarkdownStructure.node_type`, so they are the canonical
markdown types rather than one backend's spelling.

Validation is then one `case` over those typed sections:

```ruby
case section
in TypedSection(metadata: { indented: [TypedSection(metadata: { line: }), *] })
  [:indented_example, "the code block on line #{line} is indented, so it carries no language"]

in TypedSection(metadata: { rule: TypedSection, examples: [TypedSection, *], reasoning: [TypedSection, *], terminated: true })
  [:ok, "rule, example and reasoning all present"]

in TypedSection(metadata: { rule: TypedSection, examples: [TypedSection, *], reasoning: [TypedSection, *] })
  [:no_terminator, "does not end with a thematic break"]

in TypedSection(metadata: { rule: TypedSection, examples: [TypedSection, *] })
  [:no_reasoning, "nothing states why the rule holds"]

in TypedSection(name:, metadata: { rule: TypedSection })
  [:no_example, "#{name} is asserted with no code block"]

in TypedSection(metadata: { blocks: [TypedSection(type:), *] })
  [:no_rule, "the section opens with #{type}, so no bold directive states the rule"]

in TypedSection(name:)
  [:empty, "#{name} has no body"]
end
```

Arms are ordered most specific first, which is load-bearing: `indented_example` precedes the
conforming arm so an indented block is reported wherever it sits, and a section with several faults
reports the first arm that matches.

### Why the roles sit in metadata

No markdown parser in the bundle supports pattern matching — `treehaver_parse.rb` and
`ast_gems_survey.rb` record `deconstruct=false deconstruct_keys=false` for
`Commonmarker::Merge::Backend::Node`, `Commonmarker::Node` and `Markly::Node` alike. Across all 31
structuredmerge gems, `grep -rn deconstruct` matches exactly one file, `prism-merge`'s provider, and
only because Prism itself implements both hooks. Classifying into `TypedSection` sidesteps that: the
raw node rides along in `node:` and never needs to be matched directly.

The grouping has to happen somewhere, too. Ruby allows one splat per array pattern, so a conjunction
over a flat sibling sequence — rule first, fenced code somewhere, reasoning after it, break last —
cannot be written as a single pattern; `[rule, *, example, *, reasoning]` is a syntax error. Naming
the roles in metadata is what lets each arm be one flat pattern with no traversal in the validator.

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
