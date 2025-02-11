{...}: let
  networkName = "yeet";
in rec {
  yeet = {
    staticHostMap = {
      "10.10.0.1" = [
        "5.83.152.153"
      ];
    };

    ligthHouses = [
      "10.10.0.1"
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

  getConfig = lib: config: options: let
    currentName = config.networking.hostName;
    currentNode = yeet.hosts.${currentName};
  in {
    options = {
      age.secrets = lib.mkIf (config.services.networks.${networkName}.enable) {
        "nebula-${currentName}-priv" = rec {
          file = currentNode.privKeyFile;
          owner = "nebula-${networkName}";
          group = owner;
        };
      };

      services.nebula.networks.${networkName} = {
        enable = true;
        cert = config.age.secrets."nebula-${currentName}-priv".path;
        key = currentNode.privKeyFile;
        ca = ./ca.crt;

        staticHostMap = lib.mkIf (!(currentNode.lighthouse or false)) yeet.staticHostMap;
        lighthouses = lib.mkIf (!(currentNode.lighthouse or false)) yeet.ligthHouses;

        isLighthouse = currentNode.lighthouse or false;
      };
    };
  };
}
