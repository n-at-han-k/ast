# Example Rules — Conforming

Every numbered section below follows the rule/example/reasoning schema.

---

## Table of Contents

1. [Memoize Widgets](#1-memoize-widgets)
2. [Prefer tap Over Locals](#2-prefer-tap-over-locals)
3. [One Expression Per Method](#3-one-expression-per-method)

---

## 1. Memoize Widgets

**Every widget accessor must memoize with `||=`.**

A fresh widget on each call would detach the one already in the tree.

```ruby
def frame = @frame ||= Gtk::Frame.new
```

```ruby
def frame = Gtk::Frame.new
```

**Rationale:** The accessor names a single widget, so calling it twice must answer the same object.

---

## 2. Prefer tap Over Locals

**Configure objects inside `tap`, never through a local variable.**

```ruby
Editor.new.tap do |editor|
  editor.build
  editor.present(window)
end
```

**Why it matters:** The object and its configuration stay one expression, so the variable cannot
outlive the scope that configures it.

---

## 3. One Expression Per Method

**Compose operations as a single expression rather than sequential statements.**

```ruby
def add(data) = store.select(store.add(**data))
```

```ruby
def add(data)
  record = store.add(**data)
  store.select(record)
end
```

**Rationale:** The method is one operation, add then select, and the code should read as that
operation rather than as two unrelated steps.

---
