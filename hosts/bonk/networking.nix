{
  rlib,
  lib,
  config,
  ...
}:
let
  interface = "ens18";
  microvm-name = "microvm-bridge";
in
{
  systemd.network = {
    enable = true;

    netdevs = rlib.mkMerge [
      (rlib.mkIf (lib.custom.vm.microvmEnabled config) {
        "10-microvm".netdevConfig = {
          Kind = "bridge";
          Name = microvm-name;
        };
      })
    ];

    networks = rlib.mkMerge [
      {

        "10-external" = {
          matchConfig.Name = interface;
          address = [ "45.137.68.119/25" ];
          routes = [
            {
              Destination = "0.0.0.0/0";
              Gateway = "37.114.36.0";
              GatewayOnLink = true;
            }
            { Destination = "37.114.36.0/32"; }
          ];

          dns = [
            "1.1.1.1"
            "8.8.8.8"
          ];

        };
      }

      (rlib.mkIf (lib.custom.vm.microvmEnabled config) {
        "10-microvm" = {
          matchConfig.Name = microvm-name;
          addresses = [ { Address = "192.168.3.1/24"; } ];
        };

        "11-microvm" = {
          matchConfig.Name = "vm-*";
          networkConfig.Bridge = microvm-name;
        };
      })
    ];
  };

  networking = {
    hostName = "bonk";

    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
    networkmanager.enable = false;
    resolvconf.enable = false;

    nat = {
      enable = true;
      externalInterface = interface;
      internalInterfaces = if (lib.custom.vm.microvmEnabled config) then [ microvm-name ] else [ ];
    };
  };

  boot.kernel.sysctl = {
    # Allow containers to access internet
    "net.ipv4.ip_forward" = 1;
  };
}
