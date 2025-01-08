{
  config,
  ...
}:let
  vpn_port = 53;
in {
  age.secrets = {
    wireguard-vpn-setup.file = ../../secrets/wattson/wireguard-vpn-priv-key.age;  
  };

  networking.firewall = {
    allowedUDPPorts = vpn_port;
  };

  networking.wireguard.interfaces = {
    wg0 = {      
      ips = [ "10.100.0.2/24" ];
      listenPort = vpn_port;

      privateKeyFile = config.age.secrets.wireguard-vpn-setup.path;

      peers = [
        {
          # teapot
          publicKey = "cLPAuu+Pu0nTBenl+ezZyjtVNqP3WYBzKM8BPYQ4Jh8=";

          allowedIPs = [ "0.0.0.0/0" ];

          endpoint = "5.83.152.153:${toString vpn_port}";

          persistentKeepalive = 25;
        }
      ];
    };
  };
}
