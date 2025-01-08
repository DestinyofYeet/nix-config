{
  pkgs,
  config,
  ...
}:let
  vpn_port = 53;
  interface_ext = "enp6s18";
in rec {

  age.secrets = {
    wireguard-vpn-priv-key.file = ../secrets/wireguard-vpn-priv-key.age;
  };
  
  networking.nat.enable = true;
  networking.nat.externalInterface = interface_ext;
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ vpn_port ];

    trustedInterfaces = networking.nat.internalInterfaces;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.1/24" ];

      listenPort = vpn_port;

      privateKeyFile = config.age.secrets.wireguard-vpn-priv-key.path;

      peers = [
        {
          # wattson
          publicKey = "k6JnjO2BpghnwIgmDdARgi06LIHlPyQhoco6kjk6MT8=";
          allowedIPs = [ "10.100.0.2/32" ];
        }
        {
          # main
          publicKey = "CU76SCOQ1hmapZG2TWMhh/cgfjNviYUZcdbUEplW3n0=";
          allowedIPs = [ "10.100.0.3/32" ];
        }
      ];
    };
  };
}
