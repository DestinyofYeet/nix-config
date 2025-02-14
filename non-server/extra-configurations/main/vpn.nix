{
  config,
  flake,
  custom,
  secretStore,
  ...
}: let
  vpn_port = custom.wireguard.server.port;
in {
  age.secrets = {
    wireguard-vpn-priv-key.file = secretStore.secrets + /non-server/main/wireguard-vpn-priv-key.age;
  };

  networking.firewall = {
    allowedUDPPorts = vpn_port;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.0.3/32"];
      listenPort = vpn_port;

      mtu = custom.wireguard.server.mtu;

      privateKeyFile = config.age.secrets.wireguard-vpn-priv-key.path;

      peers = [
        custom.wireguard.server.peer
      ];
    };
  };
}
