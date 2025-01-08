{
  config,
  flake,
  ...
}:let
  vpn_port = flake.nixosConfigurations.teapot.config.networking.wireguard.interfaces.wg0.listenPort;
in {
  age.secrets = {
    wireguard-vpn-setup.file = ./secrets/wireguard-vpn-priv-key.age;  
  };

  networking.firewall = {
    allowedUDPPorts = vpn_port;
  };

  networking.wireguard.interfaces = {
    wg0 = {      
      ips = [ "10.100.0.3/32" ];
      listenPort = vpn_port;

      privateKeyFile = config.age.secrets.wireguard-vpn-setup.path;

      peers = [
        {
          # teapot
          publicKey = "cLPAuu+Pu0nTBenl+ezZyjtVNqP3WYBzKM8BPYQ4Jh8=";

          allowedIPs = [ "10.100.0.0/24" ];

          endpoint = "5.83.152.153:${toString vpn_port}";

          persistentKeepalive = 25;
        }
      ];
    };
  };
}
