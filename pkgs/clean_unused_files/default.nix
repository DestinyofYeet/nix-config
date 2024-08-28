{ pkgs ? import <nixpkgs> {}  }:
{
  pkg = pkgs.callPackage ./pkg.nix {};
}
