{
  flake,
  config,
  ...
}:{
  age.secrets = {
    wireguard-vpn-priv-key.file = ../secrets/wireguard-vpn-priv-key.age;
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.4/32" ];

      privateKeyFile = config.age.secrets.wireguard-vpn-priv-key.path;

      peers = [
        {
          # teapot
          publicKey = "cLPAuu+Pu0nTBenl+ezZyjtVNqP3WYBzKM8BPYQ4Jh8=";

          allowedIPs = [ "10.100.0.0/24" "10.100.0.1" ];

          endpoint = "5.83.152.153:53";

          persistentKeepalive = 25;
        }
      ];
    };
  };
}
