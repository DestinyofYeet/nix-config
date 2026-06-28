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
    ./authentikLoadBalancer.nix
    ./vaultwardenLoadBalancer.nix
    (import ../../parts/uptime.nix "uptime.uwuwhatsthis.de")
    (import ../../parts/gatus/gatus.nix { domain = "status.uwuwhatsthis.de"; })
  ];

  services.smartd.enable = lib.mkForce false;
}
