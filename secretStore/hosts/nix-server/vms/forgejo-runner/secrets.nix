{ keys, ... }@inputs:

let
  authed = keys.authed ++ [ keys.hosts.nix-server.vms.forgejo-runner.hostKey ];
in { "forgejo-registration-token.age".publicKeys = authed; }
