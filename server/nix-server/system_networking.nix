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
in {
  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
    networkmanager.enable = true;

    # no touchey !!!!!
    # this is needed to see the qbit webinterface
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
      enp37s0= {
        useDHCP = true;
      };

      ${homeRouter.interface} = {
        useDHCP = false;
        ipv4.addresses = [{ address = "${homeRouter.ip.router}"; prefixLength = 24; }];
      };
    };

    ## no touchey end
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
    };
  };

  services.resolved.enable = false;

  systemd.network.wait-online.enable = false;

  # systemd.network = {
  #   enable = true;
  #   networks."50-eth0" = {
  #     matchConfig.Name = "eth0";
  #     networkConfig = {
  #       DHCP = "ipv4";
  #       IPv6AcceptRA = true;
  #       DNS = [ ];
  #       #LLMNR = false;
  #       #useDomains = false;
  #       #multicastDNS = false;
  #       #dnsOverTls = "no";
  #       #dnssec = "no";
  #     };
  #     linkConfig.RequiredForOnline = "routable";
  #   };
  # };

  environment.etc."resolv.conf" = {
    source = pkgs.writeText "resolv.conf" ''
      # Set in /etc/nixos/system_networking.nix
      nameserver 127.0.0.1
      nameserver 8.8.8.8
    '';
  };

  networking.firewall.enable = false;
}
