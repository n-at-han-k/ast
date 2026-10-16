# gem-surveys

What the AST gems in the bundle actually provide, recorded rather than remembered.

| script | does |
| --- | --- |
| `ast_gems_survey.rb` | every AST gem in the bundle: node classes, and whether they implement `deconstruct` / `deconstruct_keys` |
| `ast_crispr_probe.rb` | walks the `Ast::Crispr` namespace — its surgical-edit contract (`read_ast`, `structural_owners`, `structure_profile`) and the markly-backed markdown adapter |

```sh
nix develop --command ruby work/gem-surveys/ast_gems_survey.rb
nix develop --command ruby work/gem-surveys/ast_crispr_probe.rb
```

`ast_gems_survey.rb` is why the `ast` gem is the one used elsewhere in `work/`: `AST::Node`
implements `deconstruct` as `[type, *children]`, so s-expression patterns like `node in [:rule, *]`
work unaided, while it has no `deconstruct_keys`. `Markly::Node` and `Commonmarker::Node` implement
neither — across all 31 structuredmerge gems, `grep -rn deconstruct` matches exactly one file,
`prism-merge`'s provider, and only because Prism itself implements both hooks.
