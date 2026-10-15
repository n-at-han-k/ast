# markdown-ast

Base markdown node types — one class per node kind, so markdown can be pattern matched the way
Prism lets Ruby be.

```sh
ruby work/markdown-ast/demo.rb work/fixtures/correct.md     # typed tree + composed patterns
ruby work/markdown-ast/discover.rb                          # the type/property matrix, with provenance
ruby work/markdown-ast/spec_corpus.rb refs/commonmark-spec/spec.txt
```

## Why these exist

No markdown parser in the bundle has a class per node kind. `Commonmarker::Node`, `Markly::Node`
and `Commonmarker::Merge::Backend::Node` are each one generic class whose kind is a string, and none
implement `deconstruct_keys`, so `in Heading(header_level: 2)` cannot be written against them.
Across the 31 structuredmerge gems `grep -rn deconstruct` matches one file, `prism-merge`'s
provider, and only because Prism itself implements both hooks. `work/ast_gems_survey.rb` and
`work/treehaver_parse.rb` hold the measurements.

## Nothing here is hardcoded

The classes are metaprogrammed from what the gem reports. `Commonmarker::Node#node_supports?` is the
authority on which properties a node's type carries, so the field list for each type is asked for,
not written down:

```ruby
PROPERTY_METHODS.select { |method| node.node_supports?(method) == true }
```

`register(node)` defines a class for a type the first time one is seen — `const_set`, an
`attr_reader` per property, plus `string_content` aliased to `literal` — and `build` registers
lazily, so a type nobody anticipated still gets a class rather than falling back to a stub. Class
names are the type symbol in CamelCase, so the names follow the parser: `item` (not `ListItem`),
`softbreak`, `taskitem`, `frontmatter`.

Every node also carries `line`, `end_line` and `children`, and `deconstruct` returns the children so
array patterns work alongside hash patterns.

## Completeness

`discover.rb` parses three corpora and reports which types each contributes, so coverage is measured
rather than asserted:

| corpus | examples | types |
| --- | --- | --- |
| `refs/commonmark-spec/spec.txt` | 655 | 23 |
| `refs/cmark-gfm/test/spec.txt` | 672 | 28 |
| `kitchen-sink.md` | 1 | 42 |

**42 types** in total. The two specs are the standard, parsed the way async-matrix vendors the Matrix
spec — `spec_corpus.rb` extracts each ` ```` example ` block and converts the `→` back to a tab. But
the specs are not sufficient on their own: `alert`, `description_list`, `description_item`,
`description_term`, `description_details`, `footnote_definition`, `footnote_reference`, `highlight`,
`insert`, `multiline_block_quote`, `shortcode`, `spoiler`, `subscript` and `superscript` are comrak
extensions that appear in neither spec, which is why `kitchen-sink.md` exists alongside them.

The 12 properties the parser exposes: `alert_type`, `fence_info`, `fenced?`, `header_level`,
`list_start`, `list_tight`, `list_type`, `literal`, `source_position`, `string_content`, `title`,
`url`. `source_position` becomes `line`/`end_line`; `string_content` is an alias of `literal` and is
kept as one. Comrak carries more internally — a table's column alignments, a task item's checked
state, a heading's setext flag — that commonmarker does not expose, so those cannot be surfaced.

## Extensions change how standard markdown parses

Discovery turns every extension on, which is necessary to see every type but wrong for parsing real
documents: with `underline` on, `__bold__` is an `Underline` rather than a `Strong`; with
`front_matter_delimiter` set, a leading `---` is `Frontmatter` rather than a `ThematicBreak`; with
`math_dollars` on, `$x$` is `Math`. The provenance column shows the effect — `underline`,
`wikilink` and `frontmatter` are all reported by the *CommonMark* corpus.

So `DISCOVERY_OPTIONS` (everything on) is used only to register classes, while `parse` defaults to
`DEFAULT_OPTIONS`, the gem's own defaults. Pass `options:` to choose deliberately.

## Composing them

Composition is the caller's business, which is the point of having base types:

```ruby
case node
in Heading(header_level: 2, children: [Text(literal:)])  then "section #{literal.inspect}"
in Paragraph(children: [Strong => strong, *])            then "bold-led #{strong.text.inspect}"
in CodeBlock(fenced?: true, fence_info:)                 then "fenced #{fence_info} block"
in CodeBlock(fenced?: false)                             then "indented block"
in List(list_type: :ordered, list_start:)                then "ordered list from #{list_start}"
end
```

`fenced?` is what distinguishes an indented block from a fenced one; a fenced block with no language
has `fence_info: ""` and `fenced?: true`, so testing the language alone conflates the two.

`Strong(children: [Text(literal:)])` deliberately does not match ``**memoize with `||=`**``, whose
children are `[Text, Code, Text]` — the types keep inline structure rather than flattening it.
`Node#text` joins the inline children when the exact shape does not matter.
