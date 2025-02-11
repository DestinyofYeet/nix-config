let
  keys = import ../pubkeys.nix;
  authed = keys.authed ++ [keys.main];
in {
  "main.key.age".publicKeys = authed;
}
