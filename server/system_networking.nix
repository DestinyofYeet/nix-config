{ config, pkgs, lib, modulesPath, ... }:

{
  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
    networkmanager.enable = true;

    # no touchey !!!!!
    # this is needed to see the qbit webinterface
    nat = {
      enable = true;
      externalInterface = "host0";
      internalInterfaces = [ "infra" "veth" ];
    };

    ## no touchey end
  };

  services.resolved.enable = false;

  systemd.network.wait-online.enable = false;

  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [ "192.168.0.250" "127.0.0.1" "10.1.1.2" ];
        port = 53;
        access-control =
          [ "192.168.0.250 allow" "127.0.0.1 allow" "10.1.1.2 allow" ];

        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;
      };
      forward-zone = [{
        name = ".";
        forward-addr =
          [ "9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net" ];
        forward-tls-upstream = true;
      }];
    };
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
        DNS = [ ];
        #LLMNR = false;
        #useDomains = false;
        #multicastDNS = false;
        #dnsOverTls = "no";
        #dnssec = "no"; 
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  environment.etc."resolv.conf" = {
    source = pkgs.writeText "resolv.conf" ''
      # Set in /etc/nixos/system_networking.nix
      nameserver 127.0.0.1
    '';
  };

  networking.firewall.enable = false;
}
