{
  pkgs,
  config,
  custom,
  ...
}:
let
  vpn_port = custom.wireguard.server.port;
in
{
  age.secrets = {
    wireguard-vpn-setup.file = ./secrets/wireguard-vpn-priv-key.age;
  };

  networking.firewall = {
    allowedUDPPorts = vpn_port;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.2/24" ];
      listenPort = vpn_port;

      mtu = custom.wireguard.server.mtu;

      privateKeyFile = config.age.secrets.wireguard-vpn-setup.path;

      peers = [
        custom.wireguard.server.peer
      ];
    };
  };
}
