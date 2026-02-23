{
  pkgs,
  config,
  custom,
  secretStore,
  ...
}:
let
  vpn_port = 1337;
  secrets = secretStore.getServerSecrets "teapot";
in
rec {
  age.secrets = {
    wireguard-vpn-priv-key = {
      file = secrets + "/wireguard-vpn-priv-key.age";
      mode = "640";
      owner = "systemd-network";
      group = "systemd-network";
    };
  };

  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ vpn_port ];

    trustedInterfaces = networking.nat.internalInterfaces;
  };

  systemd.network = {

    networks."50-wg0" = {
      matchConfig.Name = "wg0";
      address = [ "10.100.0.1/24" ];

      linkConfig.RequiredForOnline = "routable";
    };

    netdevs."50-wg0" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "wg0";
        MTUBytes = "1300";
      };

      wireguardConfig = {
        ListenPort = vpn_port;

        PrivateKeyFile = config.age.secrets.wireguard-vpn-priv-key.path;
        RouteTable = "main";
        FirewallMark = 42;
      };

      wireguardPeers = [
        {
          # pedro
          PublicKey = "7R4ogUcruPQvxxNoPp4P+sbLz47HDoY2anDvcvWnWQk=";
          AllowedIPs = [ "10.100.0.6/32" ];
          PersistentKeepalive = 10;
        }
      ];
    };
  };
}
