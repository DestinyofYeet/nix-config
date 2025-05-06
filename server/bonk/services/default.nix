{ lib, ... }: {
  imports = [
    ./nextcloud.nix
    ./postgresql.nix
    ./nginx.nix
    ./openssh.nix
    ./authelia.nix
    ./netdata.nix
    ./zabbix.nix
  ];

  services.smartd.enable = lib.mkForce false;
}
