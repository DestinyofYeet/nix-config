{
  pkgs,
  config,
  custom,
  ...
}:
let
  vpn_port = custom.wireguard.server.port;
  interface_ext = "enp6s18";
in
rec {

  age.secrets = {
    wireguard-vpn-priv-key.file = ../secrets/wireguard-vpn-priv-key.age;
  };

  networking.hosts = {
    "10.100.0.4" = [ "local.ole.blue" ];
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

      peers = custom.wireguard.peers;
    };
  };
}
