{
  flake,
  config,
  custom,
  ...
}:
{
  age.secrets = {
    wireguard-vpn-priv-key.file = ../secrets/wireguard-vpn-priv-key.age;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.4/32" ];

      mtu = custom.wireguard.server.mtu;

      privateKeyFile = config.age.secrets.wireguard-vpn-priv-key.path;

      peers = [
        custom.wireguard.server.peer
      ];
    };
  };
}
