# reference

Vendored source from blueprint-compiler, kept as the source of truth for how GTK's type and child
rules are actually modelled by a tool that does this for real.

**Licence.** blueprint-compiler is LGPL-3.0-or-later. The files are copied verbatim with their SPDX
headers and `COPYING` intact — all 21 carry `SPDX-License-Identifier: LGPL-3.0-or-later`. This
subtree is therefore LGPL; nothing else in the repo is affected, but anything derived from these
files inherits that licence.

**Provenance.** `refs/blueprint-compiler` at `8eca521ae720655c837fd1885940ed91f7517e6f`
(gitlab.gnome.org/jwestman/blueprint-compiler). Re-copy from the submodule rather than editing in
place.

## What was copied and why

| file | answers |
| --- | --- |
| `gir.py` | the GIR type model: `Class`, `Interface`, `Property`, `Signal`, `Enumeration`, `Namespace`, `Repository`, `GirContext` |
| `xml_reader.py` | their XML reader and `Element` type |
| `types.py`, `errors.py`, `ast_utils.py`, `annotations.py` | what `gir.py` depends on, including the `@validate` machinery |
| `language/gtkbuilder_child.py` | `Child`, `ChildExtension`, `ChildInternal`, `ChildType` — the generic child case |
| `language/gobject_object.py` | an object and its children |
| `language/*` (13 modules) | the widgets with hard child requirements |

## Two things this settles

**The type model is read from `.typelib`, not from `.gir`.** `gir.py` loads
`{namespace}-{version}.typelib` through `girepository-2.0` and `gi.repository`, and reads the `.gir`
XML only for documentation, searching `/usr/share/gir-1.0` — which is what `extract_gir.rb`
collects. So the binary typelib is the authoritative source for the types, and the XML is the
human-readable companion.

**Hard child requirements are not in GIR at all.** They are GtkBuilder conventions implemented in
each widget's C `buildable_add_child`, so blueprint hand-writes a module per widget. That is the
closed list of nodes with requirements beyond "any number of children":

```
Adw.AlertDialog     responses
Adw.MessageDialog   responses
Adw.Breakpoint      breakpoint setters
Gtk.ComboBoxText    combo box items
Gtk.FileFilter      file filter properties
Gtk.LevelBar        level bar offsets
Gtk.Scale           scale marks
Gtk.SizeGroup       size group properties
Gtk.StringList      items
Gtk.Widget          accessibility properties
Gtk.Widget          layout properties
Gtk.Widget          style classes
```

Each is enforced the same way — `validate_parent_type(self, "Gtk", "SizeGroup", "size group
properties")` — a runtime check that the enclosing object is of the required type. Everything else
goes through the generic `Child` path, which is why "most widgets take any number of children" is
the default and these are the exceptions.
