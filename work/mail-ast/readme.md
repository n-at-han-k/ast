# mail-ast

Pattern matching a parsed email with the `mail` gem.

```sh
nix develop --command ruby work/mail-ast/example.rb
```

## The gem has no pattern matching hooks

`Mail::Message`, `Mail::Field`, `Mail::Address` and `Mail::Part` implement neither `deconstruct` nor
`deconstruct_keys`, so a message cannot enter a `case` as it comes. `mail_patterns.rb` adds them to
the gem's own classes.

The keys are not chosen by hand. `Mail::Field::KNOWN_FIELDS` is the gem's own declaration of the
header vocabulary — 29 fields, matching its 29 `FIELDS_MAP` entries — so the field keys are derived
from it, with `-` turned into `_`:

```ruby
FIELD_KEYS = Field::KNOWN_FIELDS.map { |name| name.tr("-", "_").to_sym }.freeze
```

and seven message-level keys on top (`body`, `parts`, `attachments`, `multipart`, `charset`,
`mime_type`, `text_part`, `html_part`), giving 37 in total.

Each key prefers the gem's own accessor and only falls back to the raw header field when no accessor
exists. The first version had that the wrong way round, reading `Field#value` first, which returned
`to` as the unparsed string `"Nathan <nathan@example.com>, Reviewers <reviewers@example.com>"` and
made every array pattern fall through to the catch-all arm.

## What the keys actually return

| key | class | note |
| --- | --- | --- |
| `to`, `cc`, `from` | `Mail::AddressContainer` | an Array subclass, so array patterns work |
| `subject`, `message_id`, `in_reply_to` | `String` | |
| `references` | `String` **or** `Array` | a String for one reference, an Array for several |
| `date` | `DateTime` | |
| `body` | `String` | `nil` on a multipart message, where the content is in `parts` |

The `references` duality is the one to watch: the same field is a String or an Array depending on how
many values the header carries, so a pattern has to cover both. The example does:

```ruby
in { in_reply_to: String => parent, references: [_, _, *] => chain }
  "reply to #{parent}, #{chain.size} deep, rooted at #{chain.first}"
in { in_reply_to: String => parent, references: String => root }
  "reply to #{parent}, single reference #{root}"
```

`fixtures/multipart.eml` has one reference and `fixtures/plain.eml` has two, so both arms are
exercised.

## The example

Four `case` statements over a parsed message: classify the message, place it in a thread, summarise
recipients, and describe each part. Then `Mail::Address` and `Mail::Field` matched directly.

```
work/mail-ast/fixtures/multipart.eml
  classify:   build_failure - ast build 412 from ci@example.org, 3 parts
  thread:     reply to 20261015174500.9def456@build.example.org, single reference ...
  recipients: 2 recipients, copied to archive@example.org
  part:       plain text, 5 lines
  part:       html alternative
  part:       attachment build-412.log (text/plain)
  from:       CI Runner at ci@example.org

work/mail-ast/fixtures/plain.eml
  classify:   plain - "Re: [ast] build 412 failed on ruby 4.0.7", 1 lines
  thread:     reply to 20261016091402.4abc123@build.example.org, 2 deep, rooted at ...
  recipients: one recipient, builds@example.org
```

Named captures work inside a pattern, which is how the subject is destructured — note that
`Regexp.last_match` has to be read in the body, since a regexp pattern binds no groups itself:

```ruby
in { multipart: true, subject: /\A\[(?<project>[^\]]+)\] build (?<build>\d+) failed/, from: [sender, *], parts: }
  build = Regexp.last_match
```

`Mail::Part#deconstruct_keys` calls `super` and adds `filename`, `attachment` and `content_type`, so
a part matches on both message keys and part-specific ones.
