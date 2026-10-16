# doc-tools

The same job written three times — index a Ruby file, then pull one method's signature and
documentation out of it — with `decode`, `yard` and `rdoc`.

```sh
nix develop --command ruby work/doc-tools/with_decode.rb
nix develop --command ruby work/doc-tools/with_yard.rb
nix develop --command ruby work/doc-tools/with_rdoc.rb
```

The inputs are two real files from `refs/`, not fixtures written for the occasion:
`refs/decode/lib/decode/index.rb`, documented in decode's own tag style, and
`refs/yard/lib/yard/registry.rb`, documented in YARD's. Running every tool over both is what makes
the differences visible — each file is idiomatic for one tool and foreign to the other two.

## The APIs

| | decode | yard | rdoc |
| --- | --- | --- | --- |
| entry point | `Decode::Index.new` + `update(paths)` | `YARD.parse(path)` into a global `YARD::Registry` | `RDoc::Parser::Ruby.new(top, source, options, stats).scan` |
| state | an index object you hold | a process-global registry needing `clear` between runs | a `Store` you build, then `store.complete(:private)` |
| lookup | `definitions[qualified_name]`, or `lookup(reference)` | `YARD::Registry.at("YARD::Registry.at")` | walk `store.all_classes_and_modules` and match yourself |
| setup cost | one line | one line | four objects, and `Stats.new(store, num_files, verbosity)` |

RDoc is the only one with no lookup-by-name: you iterate modules and their `method_list` and compare
names. It also needs `options.visibility = :private` before it will report non-public methods.

## The same method, three models

`Decode::Index#lookup`, whose comment uses decode's `@parameter` / `@returns`:

```
decode   form:       def lookup(reference, relative_to: nil)
         @parameter  reference [Language::Reference]
         @parameter  relative_to [Definition?]
         @returns    [Definition?]

yard     signature:  def lookup(reference, relative_to: nil)
         parameters: [["reference", nil], ["relative_to:", "nil"]]
         docstring:  "Lookup the specified reference and return matching definitio"
         tags:       none

rdoc     signature:  lookup(reference, relative_to: nil)
         comment:    4 lines, 304 chars, verbatim, tags included as text
```

`YARD::Registry.at`, whose comment uses YARD's `@param` / `@return`:

```
yard     scope:      class
         @param      path String|:root the pathname to look for
         @return     CodeObjects::Base the object at path
         @return     nil if no object is found

decode   found as    YARD::Registry::class#at
rdoc     found as    YARD::Registry::at    singleton: true
```

## What each one is actually for

**decode** is a semantic index with a typed comment model. Tags are objects —
`Comment::Parameter`, `Comment::Returns`, `Comment::Raises` — each with `name` and `type`, and it
knows about documentation coverage directly: `coverage_relevant?` and `documented?` per definition.
It reads 14 pragmas and ignores anything else, so YARD's `@param` is invisible to it. It is the only
one of the three that will generate RBS signatures, and the only one with a `Language::Generic`
extension point for other languages.

**yard** has the richest tag model and the most forgiving one. It records multiple `@return` tags on
a single method — success and `nil` as separate entries — and parses types into a list
(`String|:root`), not a string. It also tracks `visibility` and `scope` as first-class attributes,
and gives parameter defaults (`[["relative_to:", "nil"]]`). The cost is a process-global registry:
`YARD::Registry.clear` between files or results leak.

**rdoc** has no typed-tag model at all. It hands back the comment as text, `@parameter` lines and
all, and leaves interpretation to you. What it does give is the parser the Ruby ecosystem ships with
— it is a default gem, needs no bundle, and models `call_seq`, visibility and singleton-ness on
every method.

## Counted on the same file

`refs/yard/lib/yard/registry.rb`, which has 42 code objects by RDoc's and YARD's reckoning:

| | objects | documented |
| --- | --- | --- |
| decode | 44 definitions | 24/31 coverage-relevant |
| yard | 42 objects | 28/42 |
| rdoc | 42 code objects | 28/34 methods |

The three disagree because they count different things. decode separates `Attribute` and `Alias` as
their own definitions and adds a `Singleton` container for `class << self`; yard folds constants and
modules into one object list; rdoc reports modules, methods, constants and attributes as separate
collections. Only decode has a notion of what *ought* to be documented, which is why its denominator
is 31 rather than 42.

## Naming is where they diverge most

A method defined inside `class << self` gets three different names:

| tool | name |
| --- | --- |
| yard | `YARD::Registry.at` |
| rdoc | `YARD::Registry::at`, with `singleton: true` |
| decode | `YARD::Registry::class#at` |

decode models the singleton class as a container called `class` and the method as an instance method
of it, which is literally what the Ruby source says but will not match what anyone types. Any
cross-tool work needs a name translation layer.

## Two rough edges found while writing this

`Decode::RBS` raises `LoadError: cannot load such file -- console`. `decode/rbs/method.rb` requires
`console`, which is not in decode's gemspec, so RBS generation needs `gem "console"` added by hand.

RDoc's `comment` is sometimes an `RDoc::Comment` and sometimes a plain `String`, depending on the
file, so anything reading it needs to handle both — `comment.text` raises `NoMethodError` on the
String case.
