# openapi-schemas

Is there a Ruby gem that builds an **AST** (a typed node tree you can walk, not just a Hash) for
OpenAPI documents and the JSON Schemas inside them?

Short answer: yes for traversal — `openapi3_parser` — and yes for validation — `json_schemer` and
`skooma`. Nothing offers a *mutable* tree with a printer, i.e. nothing in this space is to OpenAPI
what Prism is to Ruby.

## The six checkouts

Submodules live under `refs/` per the repo convention; this directory is for our own experiments.

| ref | version at HEAD | node model | AST-ness |
| --- | --- | --- | --- |
| `refs/openapi3_parser` | 0.10.1 | `Node::*` (34 classes) built by `NodeFactory::*` | **closest thing to a real AST** |
| `refs/json_schemer` | 2.5.0 | `Schema` tree of keyword objects per vocabulary | AST of a *schema*, not of a document |
| `refs/skooma` | 0.4.0 | `Objects::*` + per-object `Keywords::*` | OpenAPI-as-JSON-Schema-dialect tree |
| `refs/openapi_first` | 4.2.0 | `Definition` → `Router` → `Request`/`Response` | routing/validation index, not a tree |
| `refs/oas_core` | 1.4.2 | `Spec::*` value objects from `Builders::*` | a *builder*: tree out, not in |
| `refs/openapi-ruby` | 5.0.0 | `Core::Document`, component classes, DSL | DSL + middleware, no document tree |

## openapi3_parser — the one that is actually an AST

`lib/openapi3_parser/` splits cleanly into the two halves you'd expect of a parser:

* `node_factory/` — one factory per OAS object (`openapi`, `paths`, `path_item`, `operation`,
  `parameter`, `schema`, `components`, `callback`, `link`, `oauth_flows`, …), each declaring its
  allowed fields, required fields, defaults and validations. This is the grammar.
* `node/` — the corresponding immutable node classes, plus `Node::Array`, `Node::Map` and
  `Node::Placeholder` for the collection positions.

Each node carries a `Node::Context` holding `document_location` *and* `source_location`
(`Source::Location`), so a node knows which file and which JSON pointer it came from — the
equivalent of a parse node's source range, which is what makes error reporting and round-trip
tooling possible. References are resolved (`OptionalReference`, `Reference`) including recursive
and cross-file ones.

Three ways to walk it:

```ruby
document = Openapi3Parser.load_file("openapi.yaml")
document.paths["/pets"].get.summary                        # object notation
document["info"]["termsOfService"]                         # hash notation
document.node_at("#/paths/%2Fpets/get/operationId")        # JSON pointer
```

Caveat: HEAD is from **January 2025** and it is OAS 3.0-only — no 3.1, so no JSON Schema 2020-12,
`webhooks` or `jsonSchemaDialect`. It is the best tree and the least current library here.

## json_schemer — the AST of a schema

`JSONSchemer::Schema` is a genuine node: `value`, `parent`, `root`, `keywords`, `keyword_order`,
`parsed`. Each keyword is its own class under a vocabulary directory
(`draft202012/vocab/{core,applicator,validation,unevaluated,content,meta_data,format_*}.rb`), and
`openapi30/` and `openapi31/` add the OAS-specific vocabularies and meta-schemas — including
`OpenAPI31::Document`, which validates a whole OpenAPI document against the OAS meta-schema.

So the tree is per-schema and keyword-shaped, and it exists to be *evaluated* against an instance
rather than queried as a document. But it is the substrate everything else in this list stands on:
both skooma and openapi_first validate through json_schemer.

## skooma — OpenAPI expressed as a JSON Schema dialect

The interesting structural idea in the set. `lib/skooma/objects/` has `openapi`, `path_item`,
`operation`, `parameter`, `request_body`, `response`, `header`, each with a `keywords/`
subdirectory, and each object declares `kw_classes`:

```ruby
class OpenAPI < Base
  def kw_classes
    [Keywords::Info, Keywords::JSONSchemaDialect, Keywords::Paths, Keywords::Webhooks,
     Keywords::Components, Base::Keywords::Servers, ...]
  end
end
```

That is, every OpenAPI object is modelled as a json_schemer *schema* whose keywords are the OAS
fields — so the whole document becomes one keyword tree under one evaluation engine, and an
HTTP request/response is just an instance evaluated against it. OAS 3.1 only. A structural model,
but built for validation output, not for traversal or rewriting.

## The other three

* **openapi_first** — the most actively maintained (October 2026). `Definition` loads and
  ref-resolves the document, then builds a `Router` of `Request`/`Response` definitions keyed by
  path template, method and content type. Also carries a coverage reporter. Shaped for the hot
  path of request validation, so there is no walkable document tree.
* **oas_core** — runs the arrow the other way: `Yard` comment extraction → `Builders::*` →
  `Spec::*` (`Specification`, `Info`, `Paths`, `PathItem`, `Operation`, `Parameter`, `Response`,
  `MediaType`, `Reference`, …) → `Hashable#to_spec`. A clean typed model of OAS objects, but it is
  a *serializer* target: nothing parses an existing document into it.
* **openapi-ruby** — `Core::DocumentBuilder`/`Document` plus a component registry, a spec DSL and
  Rack/Rails/Hanami middleware. Toolkit, not a parser.

## What would need building

For AST work over OpenAPI the gap is a mutable, source-preserving tree:

1. openapi3_parser's `node_factory`/`node` split is the right shape and already carries source
   locations — but it is immutable, 3.0-only and dormant.
2. json_schemer's keyword classes are the right *vocabulary* model and are current.
3. Nothing round-trips: no formatter, no comment/ordering preservation in the YAML, no rewrite API.

## The pattern matcher

`api-1.json` is the Vikunja API v2.6.0 document: OpenAPI **3.1.0**, 130 path templates, 193
operations, 136 component schemas. That version rules out `openapi3_parser` — the only real AST
here is 3.0-only — so the parse goes through `openapi_first`, which is 3.1-capable and whose
`Router::Route` is already a `Data`, i.e. pattern-matchable out of the box.

| file | what it is |
| --- | --- |
| `boot.rb` | puts the `refs/openapi_first` and `refs/json_schemer` checkouts on `$LOAD_PATH` |
| `openapi_patterns.rb` | `deconstruct_keys` for `Definition`, `Router::Route`, `Request`, `Response` and `Parameter` |
| `example.rb` | `case`/`in` classifiers over those nodes, and the report |

```sh
gem install --no-document -i vendor/gems hana bigdecimal simpleidn rack   # once
ruby example.rb [document.json]
```

`hana`, `bigdecimal`, `simpleidn` and `rack` are openapi_first's and json_schemer's own
dependencies and are not in the nix `bundlerEnv`; `vendor/gems` is gitignored, and `OAS_GEM_PATH`
overrides where `boot.rb` looks. Adding the five gems to the `Gemfile` and regenerating
`gemset.nix` is the alternative, at the cost of a bundix round.

Same shape as `work/mail-ast`: the patterns file teaches the library's objects to deconstruct, the
example file does nothing but `case`/`in`. `Route` gains `method`, `item` (path ends in a template
parameter), `templated`, `operation_id`, `tags`, `security`, `params`, `statuses` and `ref` (the
component name behind a `$ref`), because a hash pattern cannot match string keys — `in {"$ref" => x}`
is a syntax error — so the raw document is not directly matchable and the node layer is what makes
the patterns possible.

What `example.rb` reports, each section driven by one `case`:

* **shape** — `paged_list` / `list` / `read` / `create` / `scoped_create` / `item_action` /
  `replace` / `upsert` / `update` / `delete`, from method plus path shape plus a find pattern over
  the parameter list (`[*, {name: "page" | "offset" | "cursor"}, *]`).
* **success / errors** — the first 2xx response with the component it returns, and whether 4xx/5xx
  are documented explicitly or only via `default`.
* **auth** — `global`, `public`, or the scheme alternatives from the operation's `security`.
* **params / body** — counts per location, and the request body's component, content type and
  whether it is required.
* **findings** — patterns that look for trouble: unauthenticated operations, writes with no
  request body, collections with no `page` parameter, optional path parameters, deprecations,
  operations with no error responses.
* **component schemas** — reference tally, unreferenced schemas, hottest schemas.

On this document: 39 `create`, 28 `paged_list`, 28 `delete`, 23 `list`, 21 `scoped_create`,
15 `replace`, 14 `update`, 13 `read`, 11 `upsert`, 1 `item_action`. Every operation documents a 2xx,
and errors go through `default` (`VikunjaErrorModel`, referenced 192 times) in 192 of 193 cases — no
operation declares an explicit 4xx, and `POST /user/export/download` documents no error response at
all. 8 operations are `public`, all 136 component schemas are referenced.
