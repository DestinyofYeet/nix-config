{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
let
  homeRouter = {
    interface = "enp42s0f3u1";
    ip = rec {
      base = "192.168.1";
      router = "${base}.1";
      dhcp-start = "${base}.10";
      dhcp-end = "${base}.200";
    };
  };

  deviceList = {
    tp-link-router = {
      mac = "00:31:92:38:B3:CF";
      ip = "192.168.1.10";
    };
    main = {
      mac = "74:56:3c:6f:b8:8a";
      ip = "192.168.1.18";
    };
  };
in {
  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
    networkmanager.enable = true;

    nat = {
      enable = true;
      externalInterface = "enp37s0";
      internalInterfaces = [
        "infra"
        "veth"
        "${homeRouter.interface}"
      ];

      internalIPs = [
        "${homeRouter.ip.base}.0/24"
      ];
    };

    interfaces = {
      enp37s0 = {
        useDHCP = true;
      };

      ${homeRouter.interface} = {
        useDHCP = false;
        ipv4 = {
          addresses = [{ address = "${homeRouter.ip.router}"; prefixLength = 24; }];
          routes = [
            {
              address = "192.168.2.0";
              prefixLength = 24;
              via = "${deviceList.tp-link-router.ip}";
            }
          ];
        };
      };
    };
  };

  services.dnsmasq = {
    enable = true;

    resolveLocalQueries = false;

    settings = {
      # disables dns
      port = 0;

      interface = homeRouter.interface;
      dhcp-authoritative = true;
      dhcp-range = [
        "${homeRouter.ip.dhcp-start}, ${homeRouter.ip.dhcp-end}, 30d"
      ];

      enable-ra = true;
      ra-param = "en,0,0";
      quiet-ra = true;

      dhcp-option = [
        "6,${homeRouter.ip.router},8.8.8.8"
      ];

      dhcp-host = [
        "${deviceList.tp-link-router.mac},TP-Link-Router,${deviceList.tp-link-router.ip}"
        "${deviceList.main.mac},main,${deviceList.main.ip}"
      ];
    };
  };

  services.resolved.enable = false;

  systemd.network.wait-online.enable = false;

  environment.etc."resolv.conf" = {
    source = pkgs.writeText "resolv.conf" ''
      # Set in /etc/nixos/system_networking.nix
      nameserver 127.0.0.1
      nameserver 8.8.8.8
    '';
  };

  networking.firewall.enable = false;
}
