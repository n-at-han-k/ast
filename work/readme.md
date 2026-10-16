# work

Scratch space for experiments. The read-only upstream checkouts live in `../refs`.

One directory per experiment, each with its own readme — nothing loose at this level.

| directory | contents |
| --- | --- |
| `prism/` | methods a Ruby file defines, via `Prism::Visitor`; needs no bundle |
| `markdown-rules/` | the rule/example/reasoning schema of a style guide, and validating documents against it with one `case`/`in` |
| `markdown-ast/` | base markdown node types — one class per kind, Prism-style |
| `mail-ast/` | `deconstruct_keys` for the `mail` gem's objects, and classifiers over them |
| `openapi-schemas/` | an OpenAPI 3.1 document parsed through the `openapi_first` checkout and reported with `case`/`in` |
| `gtk-ast/` | GIR node types generated from the grammar, and parsing a `.gir` with them |
| `rubocop/` | custom cops whose rule is one `case`/`in` over a `Data` type built from Prism primitives |
| `doc-tools/` | the same source read through `decode`, `rdoc` and `yard` |
| `gem-surveys/` | what the AST gems in the bundle provide, and their pattern-matching support |
| `fixtures/` | shared markdown fixtures (`correct.md`, `incorrect.md`), used by `markdown-rules/` and `markdown-ast/` |
