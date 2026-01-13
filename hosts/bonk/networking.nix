{ lib, ... }:
let
  interface = "enp6s18";
  microvm-name = "microvm-bridge";
in {
  systemd.network = {
    enable = true;
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Name = microvm-name;
    };

    networks = {
      "10-external" = {
        matchConfig.Name = [ interface ];
        address = [ "45.137.68.119/25" ];
        routes = [{ Gateway = "45.137.68.1"; }];

        dns = [ "1.1.1.1" "8.8.8.8" ];

      };

      "10-microvm" = {
        matchConfig.Name = microvm-name;
        addresses = [{ Address = "192.168.3.1/24"; }];
      };

      "11-microvm" = {
        matchConfig.Name = "vm-*";
        networkConfig.Bridge = microvm-name;
      };
    };
  };

  networking = {
    hostName = "bonk";
    useDHCP = false;
    useNetworkd = false;
    networkmanager.enable = false;

    nat = {
      enable = true;
      externalInterface = interface;
      internalInterfaces = [ microvm-name ];
    };
  };
}
