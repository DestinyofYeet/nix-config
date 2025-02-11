let
  keys = import ../pubkeys.nix;
  authed = keys.authed ++ [keys.nix-server];
in {
  "nix-server.key.age".publicKeys = authed;
}
