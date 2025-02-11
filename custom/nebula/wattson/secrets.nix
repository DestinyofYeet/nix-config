let
  keys = import ../pubkeys.nix;
  authed = keys.authed;
in {
  "wattson.key.age".publicKeys = authed;
}
