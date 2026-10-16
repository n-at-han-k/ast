# prism

Prism is Ruby's own parser and ships with the interpreter, so nothing here needs the bundle.

| file | does |
| --- | --- |
| `prism_example.rb` | lists the methods a Ruby file defines, via `Prism::Visitor` |
| `sample.rb` | the fixture it runs against |

```sh
ruby work/prism/prism_example.rb work/prism/sample.rb
```

## prism_example.rb

Lists the methods defined in a Ruby file: enclosing scope, `#` for instance and `.` for singleton
methods, parameter source text, line number, and the doc comment.

```sh
ruby work/prism/prism_example.rb work/prism/sample.rb
```

```
work/prism/sample.rb: 5 method(s)
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

The doc column prints blank for `work/prism/sample.rb` because that fixture carries no comments — the
repo's hook policy blocks machine-written comments, so a commented fixture needs to be added by
hand. To see the column populated, point the script at any commented Ruby file, e.g.
`ruby work/prism/prism_example.rb refs/yard/lib/yard.rb`.

## Running against the submodule instead of stdlib

`ruby -Irefs/prism/lib` does **not** work on a fresh checkout: `lib/prism/node.rb` is generated from
templates and the C extension is unbuilt, so the require fails with
`cannot load such file -- .../lib/prism/node`. Build it first:

```sh
cd refs/prism && bundle install && bundle exec rake templates compile
```

