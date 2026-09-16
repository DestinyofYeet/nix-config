{ keys, ... }@inputs:

let
  authed = keys.authed ++ [ keys.hosts.nix-server.vms.forgejo-runner.hostKey ];
in
{
  "forgejo-runner-token.age".publicKeys = authed;
}
