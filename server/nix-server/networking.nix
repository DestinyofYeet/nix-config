{ config, pkgs, lib, modulesPath, ... }:
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
    networkmanager.enable = false;

    nat = {
      enable = true;
      externalInterface = "enp37s0";
      internalInterfaces =
        [ "infra" "veth" "${homeRouter.interface}" "microvm-bridge" ];

      internalIPs = [ "${homeRouter.ip.base}.0/24" ];
    };
  };

  systemd.network = let microvm-name = "microvm-bridge";
  in {
    enable = true;
    netdevs."10-microvm".netdevConfig = {
      Kind = "bridge";
      Name = microvm-name;
    };

    networks = {
      "10-external" = {
        matchConfig.Name = [ "enp37s0" ];
        networkConfig.DHCP = "yes";
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

      "20-internal" = {
        matchConfig.Name = homeRouter.interface;
        networkConfig = {
          Address = "${homeRouter.ip.router}/24";
          DHCPServer = true;
          DNS = [ "127.0.0.1" ];
        };

        routes = [{
          Destination = "192.168.2.0/24";
          Gateway = deviceList.tp-link-router.ip;
        }];

        dhcpServerConfig = {
          EmitDNS = true;
          DNS = [ homeRouter.ip.router ];
          EmitRouter = true;
        };

        dhcpServerStaticLeases = [
          {
            MACAddress = deviceList.tp-link-router.mac;
            Address = deviceList.tp-link-router.ip;
          }
          {
            MACAddress = deviceList.main.mac;
            Address = deviceList.main.ip;
          }
        ];
      };
    };
  };

  services.resolved.enable = false;

  environment.etc."resolv.conf" = {
    source = pkgs.writeText "resolv.conf" ''
      # Set in /etc/nixos/system_networking.nix
      nameserver 127.0.0.1
      nameserver 9.9.9.9
    '';
  };

  networking.firewall.enable = false;
}
