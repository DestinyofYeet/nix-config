let
  keys = import ./pubkeys.nix;
  functions = import ./functions.nix { };

  args = { inherit functions keys; };

  inherit (functions) importFolder;
in (importFolder "non-server/" args) // (importFolder "servers/" args)
