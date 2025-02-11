let
  keys = import ../pubkeys.nix;
  authed = keys.authed ++ [keys.teapot];
in {
  "teapot.key.age".publicKeys = authed;
  "ca.key.age".publicKeys = authed;
}
