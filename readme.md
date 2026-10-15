# ast

Research repo for Ruby AST work.

| directory | contents |
| --- | --- |
| `refs/` | upstream checkouts as submodules; read-only reference material |
| `work/` | our own experiments |
| `notebooks/` | the research notebook |

## Submodules

All under `refs/`:

| path | upstream | why |
| --- | --- | --- |
| `refs/prism` | https://github.com/ruby/prism | the Ruby parser; produces the CRuby AST |
| `refs/decode` | https://github.com/socketry/decode | source and documentation analysis over a Ruby parser |
| `refs/rubocop` | https://github.com/rubocop/rubocop | AST-driven linting; node patterns via `rubocop-ast` |
| `refs/structuredmerge-ruby` | https://github.com/structuredmerge/structuredmerge-ruby | monorepo of structured-merge gems, including `prism-merge` and `ast-crispr-ruby-prism` |
| `refs/rdoc` | https://github.com/ruby/rdoc | Ruby's bundled documentation generator; its own parser and code-object model |
| `refs/yard` | https://github.com/lsegal/yard | documentation generator with a tag-based object model and its own Ruby parsers |
| `refs/ruby-next` | https://github.com/ruby-next/ruby-next | transpiles modern syntax to older Ruby; the one here that rewrites a tree rather than only reading it |

```sh
git clone --recurse-submodules <this repo>
# or, in an existing clone:
git submodule update --init --recursive
```

## Work

See `work/readme.md`. `work/prism_example.rb` lists the methods defined in a Ruby file using
`Prism::Visitor`; it needs no bundle, since Prism ships with Ruby 3.4.

```sh
ruby work/prism_example.rb work/sample.rb
```

## Notebook

`notebooks/ast-research.ipynb` drives the submodules from a Python kernel via subprocesses.
The Jupyter server root is `$HOME`, so the notebook path on the server is
`usb/ast/notebooks/ast-research.ipynb`.
