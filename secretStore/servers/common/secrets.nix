{ keys, ... }@inputs:
let
  authed = keys.authed ++ [
    keys.hosts.nix-server.hostKey
    keys.hosts.teapot.hostKey
    keys.hosts.bonk.hostKey
  ];
in {
  "cloudflare-api-env.age".publicKeys = authed;

  "authentik-env.age".publicKeys = authed;
  "authentik-ldap-env.age".publicKeys = authed;
}
