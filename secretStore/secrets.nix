let
  keys = import ./pubkeys.nix;
  functions = import ./functions.nix {};

  inherit (functions) importFolder;
in
  (importFolder "non-server/" {inherit keys;})
  // (importFolder "servers/" {inherit keys;})
# // (functions.addPrefix "test/" (import ./test/secrets.nix {inherit keys;}))

