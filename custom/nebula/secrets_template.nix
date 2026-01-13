{ system, vm ? null }:
let
  keys = import ../../secretStore/pubkeys.nix;
  authed = keys.authed ++ (if vm == null then
    [ keys.hosts.${system}.hostKey ]
  else
    [ keys.hosts.${system}.vms.${vm}.hostKey ]);

  ageName = if vm == null then system else "${system}-${vm}";
in { "${ageName}.key.age".publicKeys = authed; }
