{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:

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
      internalInterfaces = [
        "infra"
        "veth"
      ];
    };

    ## no touchey end
  };

  services.resolved.enable = false;

  systemd.network.wait-online.enable = false;

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
      nameserver 8.8.8.8
    '';
  };

  networking.firewall.enable = false;
}
