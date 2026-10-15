# Example Rules — Non-conforming

Each numbered section below breaks the schema in exactly one way.

---

## 1. Missing Rule

```ruby
def frame = @frame ||= Gtk::Frame.new
```

**Rationale:** The section opens with code, so no bold directive states what the rule actually is.

---

## 2. Missing Example

**Never remove working functionality while adding a feature.**

1. Verify the current behaviour
2. Add the new behaviour
3. Check the old behaviour still holds

**Anti-pattern:** Rewriting a component to add a feature and breaking what already worked.

---

## 3. Unfenced Example

**Chain the list models in a fixed order.**

    ListStore -> FilterListModel -> SortListModel -> SingleSelection

**Rationale:** The diagram is indented rather than fenced, so it carries no language and cannot be
extracted as code.

---

## 4. Missing Reasoning

**Always show every field, even when its value is empty.**

```ruby
def show(contact)
  email_value.label = contact.email
end
```

---

## 5. Missing Terminator

**Applications start with a single expression.**

```ruby
ContactsApp.new.build.run
```

**The pattern:** new to instantiate, build to wire the UI, run to start the loop.
