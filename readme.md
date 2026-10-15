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
| `refs/commonmark-spec` | https://github.com/commonmark/commonmark-spec | the CommonMark standard; `spec.txt` carries 655 conformance examples |
| `refs/cmark-gfm` | https://github.com/github/cmark-gfm | GitHub's GFM spec and reference implementation (a fork of `commonmark/cmark`); `test/spec.txt` carries 672 examples |

```sh
git clone --recurse-submodules <this repo>
# or, in an existing clone:
git submodule update --init --recursive
```

## Dev shell

`nix develop`, or `direnv allow` once and it loads on `cd`.

| shell | contents |
| --- | --- |
| `nix develop` | `ruby_4_0` (4.0.7) with the `Gemfile` gems from `bundlerEnv`, `rubyfmt`, plus the shared `mkRubyShell` base: `bundix`, `git`, `libyaml`, `openssl`, `overmind`, `tmux`, `pkg-config` and a C toolchain |
| `nix develop .#notebook` | the above plus `python3` with `jupyterlab`/`notebook`/`ipykernel`, and `iruby` (a Ruby Jupyter kernel) |

## Gems

`Gemfile` lists the released gem for each thing under `refs/`, so `gemset.nix` is generated from
rubygems the normal way:

```sh
bundle lock
bundix -l
```

Note that these are the *published* gems, not the checkouts: `refs/` is at upstream HEAD, while the
bundle resolves to the last release. Prism is the clearest case — `refs/prism` is 2.0.0.rc1 while
the bundle gets 1.9.0, because `rubocop-ast` requires `prism ~> 1.7` and `prism-merge` requires
`~> 1.6`. A path-sourced Gemfile cannot express this repo anyway, since bundix only reads
`Gemfile.lock` and has no way to hash a working tree.

`commonmarker` and `tree_sitter_language_pack` ship precompiled platform gems. `Gemfile.lock` names
every platform they publish, and bundix collapses that to a single platform-less entry carrying one
arbitrary platform's checksum, which then fails to match on fetch. `flake.nix` rewrites those two
entries into the platform gem for the system being built for, with the checksums `Gemfile.lock`
already records per platform. **Bumping either gem needs those hashes regenerated.**

Both shells set `RUBYOPT=""` as a derivation attribute rather than unsetting it in `shellHook`,
because the shared `mkRubyShell` base hook runs `bundix -l` before any hook of ours would get a
chance; with an inherited `RUBYOPT=-rrubyshell ...` that call fails with
`cannot load such file -- rubyshell`. `.envrc` also unsets it for the direnv path.

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
