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

## Dev shell

`nix develop`, or `direnv allow` once and it loads on `cd`.

| shell | contents |
| --- | --- |
| `nix develop` | `ruby_3_4` (3.4.9, matching the system ruby), `rubyfmt`, plus the shared `mkRubyShell` base: `bundix`, `git`, `libyaml`, `openssl`, `overmind`, `tmux`, `pkg-config` and a C toolchain |
| `nix develop .#notebook` | the above plus `python3` with `jupyterlab`/`notebook`/`ipykernel`, and `iruby` (a Ruby Jupyter kernel) |

Both shells `unset RUBYOPT`. Without that, an inherited `RUBYOPT=-rrubyshell ...` makes every
`ruby` invocation fail with `cannot load such file -- rubyshell`. `.envrc` unsets it too, since
direnv does not run the flake's `shellHook` conditions the same way.

`BUNDLE_PATH` points at `.bundle/vendor` in the repo root rather than at each submodule, because
Nix's ruby cannot write to its own gem directory in the store and because per-submodule
`vendor/bundle` directories would dirty the upstream checkouts.

The `notebook` shell starts a *separate* Jupyter server from the one the research notebook is
currently driven through (that one is rooted at `$HOME`; see below).

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
