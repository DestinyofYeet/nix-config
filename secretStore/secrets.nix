let
  keys = import ./pubkeys.nix;
  functions = import ./functions.nix;

  lib = (import <nixpkgs> { }).lib;

  args = { inherit functions keys lib; };

  importFolder = (functions.getImportFolder ./.);
in (importFolder "non-server/" args) // (importFolder "servers/" args)
