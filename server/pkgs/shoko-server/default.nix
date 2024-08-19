{ pkgs ? import <nixpkgs> {} }:{
  server = pkgs.callPackage ./shoko-server-pkg.nix {};
}
