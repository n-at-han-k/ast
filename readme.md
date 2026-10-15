# ast

Research repo for Ruby AST work.

## Submodules

| path | upstream | why |
| --- | --- | --- |
| `prism` | https://github.com/ruby/prism | the Ruby parser; produces the CRuby AST |
| `decode` | https://github.com/socketry/decode | source and documentation analysis over a Ruby parser |
| `rubocop` | https://github.com/rubocop/rubocop | AST-driven linting; node patterns via `rubocop-ast` |
| `structuredmerge-ruby` | https://github.com/structuredmerge/structuredmerge-ruby | monorepo of structured-merge gems, including `prism-merge` and `ast-crispr-ruby-prism` |

```sh
git clone --recurse-submodules <this repo>
# or, in an existing clone:
git submodule update --init --recursive
```

## Notebook

`notebooks/ast-research.ipynb` drives the submodules from a Python kernel via subprocesses.
The Jupyter server root is `$HOME`, so the notebook path on the server is
`usb/ast/notebooks/ast-research.ipynb`.
