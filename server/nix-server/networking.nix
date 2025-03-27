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
      internalInterfaces = [ "infra" "veth" "${homeRouter.interface}" ];

      internalIPs = [ "${homeRouter.ip.base}.0/24" ];
    };
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-external" = {
        matchConfig.Name = "enp37s0";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "routable";
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

  # services.resolved = {
  #   enable = true;
  #   dnssec = "false";
  #   domains = [ "~." ];
  #   fallbackDns = [ "9.9.9.9" ];
  #   extraConfig = ''
  #     DNS=127.0.0.1
  #   '';
  # };

  services.resolved.enable = false;

  environment.etc."resolv.conf" = {
    source = pkgs.writeText "resolv.conf" ''
      # Set in /etc/nixos/system_networking.nix
      nameserver 127.0.0.1
      nameserver 8.8.8.8
    '';
  };

  networking.firewall.enable = false;
}
