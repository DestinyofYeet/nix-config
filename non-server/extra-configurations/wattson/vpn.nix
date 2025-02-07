{
  pkgs,
  config,
  custom,
  ...
}: {
  age.secrets = {
    wireguard-vpn-priv-key.file = ./secrets/wireguard-vpn-priv-key.age;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      dynamicEndpointRefreshSeconds = 60;
      ips = ["10.100.0.2/32"];

      mtu = custom.wireguard.server.mtu;

      privateKeyFile = config.age.secrets.wireguard-vpn-priv-key.path;

      peers = [
        custom.wireguard.server.peer
      ];
    };
  };
}
