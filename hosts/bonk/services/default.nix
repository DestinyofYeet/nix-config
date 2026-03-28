{ lib, ... }:
{
  imports = [
    ../../parts/ha-haproxy
    ../../parts/idp/cert.nix
    ./nextcloud.nix
    ./postgresql.nix
    ./nginx.nix
    ./openssh.nix
    # ./authelia.nix
    # ./zabbix.nix
    ./beszel-agent.nix
    ./authentikLoadBalancer.nix
    ./vaultwardenLoadBalancer.nix
    (import ../../parts/uptime.nix "uptime.uwuwhatsthis.de")
  ];

  services.smartd.enable = lib.mkForce false;
}
