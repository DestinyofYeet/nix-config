{ flake, pkgs, inputs, config, lib, ... }:
let
  mkVM = name: settings: {
    "${name}" = {
      pkgs = settings.pkgs ? pkgs;
      specialArgs = flake.defaultSpecialArgs;
      config = lib.mkMerge [
        {
          microvm = {
            interfaces = [{
              type = "tap";
              id = "vm-${name}";
              mac = settings.mac;
            }];
          };

          system.stateVersion = config.system.stateVersion;

          networking.useNetworkd = false;
          systemd.network = {
            enable = true;
            networks."20-lan" = {
              matchConfig.Name = "enp*";
              networkConfig = {
                Address = [ "${settings.ip}/24" ];
                Gateway = "192.168.3.1";
                DNS = [ "192.168.3.1" "9.9.9.9" ];
                IPv6AcceptRA = true;
                DHCP = "no";
              };
            };
          };
          networking.useDHCP = lib.mkForce false;
        }

        settings.config
      ];
    };
  };

in {
  imports = [ ./nginx.nix ];
  microvm = {
    host.enable = true;
    vms = lib.mkMerge [
      (mkVM "rofl" {
        ip = "192.168.3.10";
        mac = "02:00:00:00:00:01";
        config = { imports = [ ./rofl ./baseline ]; };
      })
    ];
  };
}
