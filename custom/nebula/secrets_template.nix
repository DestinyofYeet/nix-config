{system}: let
  keys = import ../pubkeys.nix;
  authed = keys.authed ++ [keys.systems.${system}];
in {
  "${system}.key.age".publicKeys = authed;
}
