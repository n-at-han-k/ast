{
  description = "ast — Ruby AST research";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
    mine.url = "github:n-at-han-k/flake.nix";
    mine.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, mine, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = mine.lib.${system};

        ruby = pkgs.ruby_4_0;

        platformGems = {
          commonmarker = {
            x86_64-linux = {
              platform = "x86_64-linux";
              sha256 = "10187768405j6w6bwff9b2nxvqwg8r4253lj8li05agw1c652p4l";
            };
            aarch64-linux = {
              platform = "aarch64-linux";
              sha256 = "0y4lhq7xd9gphp9plag7np42ddfys8zrpn8dxdkf1ph3lbg6gcgf";
            };
            x86_64-darwin = {
              platform = "x86_64-darwin";
              sha256 = "0g9nw864vxmk663igz4dav8n3xnkmj81qh8nvkn2b61is0787q01";
            };
            aarch64-darwin = {
              platform = "arm64-darwin";
              sha256 = "17m7i9x38x4iwil7vqggzcmlm1fyhc1v8a6c6d98nc74s68wiv1r";
            };
          };

          nokogiri = {
            x86_64-linux = {
              platform = "x86_64-linux-gnu";
              sha256 = "0sm0h74pnjfxl1y2mzdy5wmysrc4rwnwwlnp34zmx4981d2ax7rp";
            };
            aarch64-linux = {
              platform = "aarch64-linux-gnu";
              sha256 = "13qsqdvwdnykaja86ks2lwyb828j5dv5rpakg82hbr3d99jgns8j";
            };
            x86_64-darwin = {
              platform = "x86_64-darwin";
              sha256 = "0l85yw2c4iwhb7cpwfr3xyjx9lwmcpbkqjx7ajchxw71sdbp1lbz";
            };
            aarch64-darwin = {
              platform = "arm64-darwin";
              sha256 = "09rmsqfzkipxi4zyp0wm54xcynni2ww9bipb6rxmkrl66a2vjvd4";
            };
          };

          tree_sitter_language_pack = {
            x86_64-linux = {
              platform = "x86_64-linux";
              sha256 = "01hzr4v17hcjsp3b0i9kx87j7w9yfb89ncslymblh72yxgd4ixdy";
            };
            aarch64-linux = {
              platform = "aarch64-linux";
              sha256 = "1d6l02v4m94x2r0lh82n0q0g43xwr3gfslmq0i5rhwf61q63k41c";
            };
            x86_64-darwin = {
              platform = "x86_64-darwin";
              sha256 = "1v60nxfk23g7apjbnr8k4dfnq0p79k95m05mxqk8aw3w12qhah8h";
            };
            aarch64-darwin = {
              platform = "arm64-darwin";
              sha256 = "0fn6f4kn112xqfl2rsdjwz4rw5g64bz40aq5sa3cdl6z46wysxd3";
            };
          };
        };

        usePlatformGem = gemset: name: table:
          let
            selected = table.${system} or (throw
              "${name} has no precompiled gem for ${system}");
            generic = gemset.${name};
          in
          gemset // {
            ${name} = generic // {
              version = "${generic.version}-${selected.platform}";
              source = generic.source // { sha256 = selected.sha256; };
            };
          };

        gemset = builtins.foldl'
          (acc: name: usePlatformGem acc name platformGems.${name})
          (import ./gemset.nix)
          (builtins.attrNames platformGems);

        gems = pkgs.bundlerEnv {
          name = "ast-gems";
          inherit ruby gemset;
          gemfile = ./Gemfile;
          lockfile = ./Gemfile.lock;
        };

        python = pkgs.python3.withPackages (ps: with ps; [
          jupyterlab
          notebook
          ipykernel
        ]);

        girLibraries = with pkgs; [
          glib
          gtk4
          libadwaita
          pango
          gdk-pixbuf
          graphene
          harfbuzz
          cairo
          at-spi2-core
          gobject-introspection
        ];

        girPath = pkgs.lib.makeSearchPathOutput "dev" "share/gir-1.0" girLibraries;

        shellEnv = /* bash */ ''
          export BUNDLE_GEMFILE="$PWD/Gemfile"
          export BUNDLE_FORCE_RUBY_PLATFORM=false

          export LANG="''${LANG:-C.UTF-8}"
          export LC_ALL="''${LC_ALL:-$LANG}"
        '';
      in
      {
        devShells.default = lib.mkRubyShell {
          RUBYOPT = "";

          buildInputs = [
            gems
            gems.wrappedRuby

            pkgs.rubyfmt
          ];

          shellHook = shellEnv;
        };

        devShells.gtk = lib.mkRubyShell {
          RUBYOPT = "";
          GIR_PATH = girPath;

          buildInputs = [
            gems
            gems.wrappedRuby
          ] ++ girLibraries;

          shellHook = shellEnv;
        };

        devShells.notebook = lib.mkRubyShell {
          RUBYOPT = "";

          buildInputs = [
            gems
            gems.wrappedRuby

            python
            pkgs.iruby
          ];

          shellHook = shellEnv + /* bash */ ''
            export JUPYTER_PLATFORM_DIRS=1
          '';
        };
      }
    );
}
