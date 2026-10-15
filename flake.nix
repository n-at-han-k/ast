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

        ruby = pkgs.ruby_3_4;

        python = pkgs.python3.withPackages (ps: with ps; [
          jupyterlab
          notebook
          ipykernel
        ]);
      in
      {
        devShells.default = lib.mkRubyShell {
          buildInputs = [
            ruby
            pkgs.rubyfmt
          ];

          shellHook = /* bash */ ''
            unset RUBYOPT

            export BUNDLE_PATH="''${BUNDLE_PATH:-$PWD/.bundle/vendor}"
            export BUNDLE_FORCE_RUBY_PLATFORM=false

            export LANG="''${LANG:-C.UTF-8}"
            export LC_ALL="''${LC_ALL:-$LANG}"
          '';
        };

        devShells.notebook = lib.mkRubyShell {
          buildInputs = [
            ruby
            python
            pkgs.iruby
          ];

          shellHook = /* bash */ ''
            unset RUBYOPT

            export BUNDLE_PATH="''${BUNDLE_PATH:-$PWD/.bundle/vendor}"

            export LANG="''${LANG:-C.UTF-8}"
            export LC_ALL="''${LC_ALL:-$LANG}"

            export JUPYTER_PLATFORM_DIRS=1
          '';
        };
      }
    );
}
