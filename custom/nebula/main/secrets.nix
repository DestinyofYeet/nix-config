let
  keys = import ../pubkeys.nix;
  authed = keys.authed;
in {
  "main.key.age".publicKeys = authed;
}
