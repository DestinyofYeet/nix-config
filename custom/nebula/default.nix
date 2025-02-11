{...}: let
  networkName = "yeet";
in rec {
  yeet = {
    staticHostMap = {
      "172.27.255.1" = [
        "ole.blue:4242"
      ];
    };

    ligthHouses = [
      "172.27.255.1"
    ];

    hosts = {
      teapot = {
        lighthouse = true;
        privKeyFile = ./teapot/teapot.key.age;
        publicKeyFile = ./teapot/teapot.crt;
      };

      nix-server = {
        privKeyFile = ./nix-server/nix-server.key.age;
        publicKeyFile = ./nix-server/nix-server.crt;
      };

      wattson = {
        privKeyFile = ./wattson/wattson.key.age;
        publicKeyFile = ./wattson/wattson.crt;
      };

      main = {
        privKeyFile = ./main/main.key.age;
        publicKeyFile = ./main/main.crt;
      };
    };
  };

  getConfig = lib: config: let
    currentName = config.networking.hostName;
    currentNode = yeet.hosts.${currentName};
    isLightHouse = currentNode.lighthouse or false;
  in {
    age.secrets = {
      "nebula-${currentName}-priv" = rec {
        file = currentNode.privKeyFile;
        owner = "nebula-${networkName}";
        group = owner;
      };
    };

    services.nebula.networks.${networkName} = {
      enable = true;
      key = config.age.secrets."nebula-${currentName}-priv".path;
      cert = currentNode.publicKeyFile;
      ca = ./ca.crt;

      staticHostMap = lib.mkIf (!(isLightHouse)) yeet.staticHostMap;
      lighthouses = lib.mkIf (!(isLightHouse)) yeet.ligthHouses;

      isLighthouse = isLightHouse;
      listen = lib.mkIf isLightHouse {
        host = "0.0.0.0";
        port = 4242;
      };

      settings = {
        punchy.punch = lib.mkIf (!isLightHouse) true;
      };

      firewall = rec {
        inbound = [
          {
            host = "any";
            port = "any";
            proto = "any";
          }
        ];

        outbound = inbound;
      };
    };

    networking.firewall = {
      allowedUDPPorts = lib.mkIf isLightHouse [4242];
      trustedInterfaces = ["nebula.${networkName}"];
    };
  };
}
