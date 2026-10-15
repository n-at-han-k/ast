# gtk-ast

GTK and libadwaita describe their own APIs in GIR — GObject Introspection Repository XML — which is
a machine-readable schema in the same role `CommonMark.dtd` plays for markdown and `config.yml`
plays for Prism.

```sh
nix develop .#gtk --command ruby work/gtk-ast/extract_gir.rb          # resolve and report
nix develop .#gtk --command ruby work/gtk-ast/extract_gir.rb --write  # copy into work/gtk-ast/gir
```

## Where the .gir files come from

The usual advice is `/usr/share/gir-1.0` plus a distribution's `-dev` package. On NixOS they live in
the `dev` output of each package instead, so `flake.nix` builds the search path rather than hunting
for them:

```nix
girLibraries = with pkgs; [
  glib gtk4 libadwaita pango gdk-pixbuf graphene harfbuzz cairo at-spi2-core gobject-introspection
];

girPath = pkgs.lib.makeSearchPathOutput "dev" "share/gir-1.0" girLibraries;
```

`devShells.gtk` exports that as `GIR_PATH`, which is the only thing `extract_gir.rb` needs. The
files are not committed — 27M for the closure — so `work/gtk-ast/gir/` is gitignored and rebuilt on
demand.

Note that libadwaita's repository is **`Adw-1.gir`**, not `Adwaita-1.gir`; the latter name belongs to
the icon theme.

## The include closure

A `.gir` declares its dependencies with `<include>`, so asking for Gtk and Adw pulls in 13 more.
`extract_gir.rb` walks that graph from `Gtk-4.0` and `Adw-1`, reports anything the search path cannot
satisfy, and exits non-zero if the closure is incomplete:

```
Gtk-4.0                  8.0M  Gdk-4.0, Gsk-4.0
Adw-1                    2.2M  Gio-2.0, Gtk-4.0
Gdk-4.0                  1.6M  GdkPixbuf-2.0, Gio-2.0, Pango-1.0, PangoCairo-1.0, cairo-1.0
Gsk-4.0                  0.6M  Gdk-4.0, Graphene-1.0
Gio-2.0                  5.9M  GLib-2.0, GModule-2.0, GObject-2.0
GdkPixbuf-2.0            0.3M  GModule-2.0, Gio-2.0
Pango-1.0                1.0M  GObject-2.0, Gio-2.0, HarfBuzz-0.0, cairo-1.0
PangoCairo-1.0           0.0M  GObject-2.0, Pango-1.0, cairo-1.0
cairo-1.0                0.0M  GObject-2.0
Graphene-1.0             0.6M  GObject-2.0
GLib-2.0                 3.8M
GModule-2.0              0.1M  GLib-2.0
GObject-2.0              1.2M  GLib-2.0
HarfBuzz-0.0             1.4M  GObject-2.0, freetype2-2.0
freetype2-2.0            0.0M

closure of Gtk-4.0, Adw-1: 15 repositories, 26.7M
missing from GIR_PATH: []
```

39 repositories are reachable on the search path in total; the closure takes the 15 that Gtk and Adw
actually need.

One parsing detail worth keeping: `<namespace>` spans several lines in a real `.gir`, with `name` and
`version` on separate ones, so a single-line regex finds neither and silently reports an empty
closure.
