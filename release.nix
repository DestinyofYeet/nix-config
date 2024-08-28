{ ... }:
let 
  nixpkgs = (import <nixpkgs> {});

  forAllSystems = function:
    nixpkgs.lib.genAttrs [
      "x86_64-linux"
    ]
    (system: function (import <nixpkgs> { inherit system; config.allowUnfree = true; }));

in {
  packages = forAllSystems (pkgs: {

      default = {
        add-replay-gain = pkgs.callPackage ./pkgs/add-replay-gain/add-replay-gain-pkg.nix {};
        clean-unused-files = pkgs.callPackage ./pkgs/clean_unused_files/pkg.nix {};
      };
  });
}
