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
    ./netdata.nix
    # ./zabbix.nix
    ./beszel-agent.nix
    ./authentikLoadBalancer.nix
  ];

  services.smartd.enable = lib.mkForce false;
}
