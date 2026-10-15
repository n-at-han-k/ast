# work

Scratch space for experiments. The read-only upstream checkouts live in `../refs`.

| script | does |
| --- | --- |
| `prism_example.rb` | lists the methods a Ruby file defines, via Prism |
| `md_nodes.rb` | shared commonmarker traversal used by the Markdown scripts |
| `markdown_ast.rb` | dumps a Markdown AST (`--outline`, `--counts`) |
| `md_shape.rb` | prints the block shape of each section — how the schema below was derived |
| `md_schema.rb` | checks a document against the rule/example/reasoning schema (`--strict` to exit non-zero) |
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

`md_schema.rb` treats an h2 titled `N. Name` as a rule section and skips the rest (title, table of
contents, summary table). Run against its own source document, **14 of 17 sections conform**:

```
FAIL line 366  12. Incremental Development Rule   - no example: section has no code block
FAIL line 431  14. ListModel Chain Pattern        - unfenced example: 1 code block without a language
FAIL line 515  16. Delete with Undo Pattern       - no rule: first block is code_block, not a bold directive
```

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
