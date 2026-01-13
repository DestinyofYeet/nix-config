{ lib, ... }:
let
  interface = "ens18";
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
        matchConfig.Name = interface;
        address = [ "5.83.152.153/26" ];

        routes = [{ Gateway = "5.83.152.129"; }];

        dns = [ "1.1.1.1" "8.8.8.8" ];

        linkConfig.RequiredForOnline = "routable";
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
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
    networkmanager.enable = false;
    resolvconf.enable = false;

    hostName = "teapot";

    nat = {
      enable = true;
      externalInterface = interface;
      internalInterfaces = [ microvm-name ];
    };
  };

  boot.kernel.sysctl = {
    # Allow containers to access internet
    "net.ipv4.ip_forward" = 1;
  };
}
