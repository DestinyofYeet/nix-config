let
  keys = import ../pubkeys.nix;
  authed = keys.authed ++ [keys.wattson];
in {
  "wattson.key.age".publicKeys = authed;
}
