# markdown-ast

Base markdown node types — one class per node kind, so markdown can be pattern matched the way
Prism lets Ruby be.

```sh
ruby work/markdown-ast/demo.rb work/fixtures/correct.md
```

## Why these exist

No markdown parser in the bundle has a class per node kind. `Commonmarker::Node`,
`Markly::Node` and `Commonmarker::Merge::Backend::Node` are each one generic class whose kind is a
string, and none of them implement `deconstruct_keys`, so `in Heading(level: 2)` cannot be written
against them. Across the 31 structuredmerge gems only `prism-merge` uses `deconstruct`, and only
because Prism itself implements it. `work/ast_gems_survey.rb` and `work/treehaver_parse.rb` record
the measurements.

`Ast::Merge::SectionTyping::TypedSection` is a *section* wrapper carrying a type symbol, not a node
type, and `NodeTypeNormalizer` supplies canonical type *symbols* rather than classes. So the node
types had to be written, with Prism as the reference.

## The types

22 types cover CommonMark plus the GFM table extension:

```
Document Heading Paragraph CodeBlock HtmlBlock BlockQuote List ListItem ThematicBreak
Table TableRow TableCell FootnoteDefinition
Text Code Emph Strong Link Image SoftBreak LineBreak HtmlInline
```

They are generated from the single `SPEC` table in `markdown_types.rb`, each class carrying
`deconstruct_keys` for its named fields, `deconstruct` for positional children, and `line`. Fields
exist only where a kind needs them:

| type | fields |
| --- | --- |
| `Heading` | `level` |
| `CodeBlock` | `lang`, `code` |
| `List` | `ordered`, `tight` |
| `Link`, `Image` | `url`, `title` |
| `Text`, `Code`, `HtmlBlock`, `HtmlInline` | `content` |
| everything else | none beyond `children` and `line` |

Parsing goes through TreeHaver and kinds are mapped with
`Markdown::Merge::NodeTypeNormalizer.canonical_type`, so the table is keyed on canonical markdown
types rather than one backend's spelling. Anything unmapped becomes `Unknown(original:)`; the
613-line `work/style-rules.md` produces none.

## Composing them

Composition is the caller's business, which is the point of having base types:

```ruby
case node
in Heading(level: 2, children: [Text(content:)])  then "section #{content.inspect}"
in Paragraph(children: [Strong => strong, *])     then "bold-led #{strong.text.inspect}"
in CodeBlock(lang: String => lang)                then "fenced #{lang} block"
in CodeBlock(lang: nil)                           then "indented block"
in List(ordered: true, children:)                 then "ordered list of #{children.size}"
end
```

`Strong(children: [Text(content:)])` deliberately does not match ``**memoize with `||=`**``, whose
children are `[Text, Code, Text]` — the types keep inline structure rather than flattening it.
`Node#text` joins the inline children when the exact shape does not matter.
