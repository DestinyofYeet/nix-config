{ keys, ... }@inputs:
let
  authed = keys.authed ++ [
    keys.hosts.nix-server.hostKey
    keys.hosts.teapot.hostKey
    keys.hosts.bonk.hostKey
    keys.hosts.nix-server.vms.ha-vm.hostKey
    keys.hosts.teapot.vms.ha-vm.hostKey
    keys.hosts.bonk.vms.ha-vm.hostKey
  ];
in
{
  "cloudflare-api-env.age".publicKeys = authed;

  "authentik-env.age".publicKeys = authed;
  "authentik-ldap-env.age".publicKeys = authed;

  "ha-vm-patroni-replication-pw.age".publicKeys = authed;
  "ha-vm-patroni-superuser-pw.age".publicKeys = authed;
}
