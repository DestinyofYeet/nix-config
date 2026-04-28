{ secretStore, config, ... }:
let
  secrets = secretStore.getServerSecrets "teapot";

  machines = import ../../../custom/nebula/machines.nix;
in
{
  age.secrets = {
    syncthing-gui-file = {
      file = secrets + "/syncthing-gui-pass.age";
      owner = "syncthing";
      group = "syncthing";
    };
  };

  services.syncthing = {
    enable = true;

    guiAddress = "127.0.0.1:8384";
    guiPasswordFile = config.age.secrets.syncthing-gui-file.path;

    settings = {
      gui = {
        user = "admin";
        insecureSkipHostcheck = true;
      };

      devices = {
        nix-server = {
          id = "TL3POH2-BE5EXKK-K4HJFLD-WHU2FVQ-7RYUQ76-OIW6L4P-DQHY5DC-EGALKQC";
          numconnections = 10;
        };
      };
    };
  };

  services.nginx.virtualHosts."syncthing.teapot.neb.ole.blue" = {
    useACMEHost = "wildcard.teapot.neb.ole.blue";
    forceSSL = true;

    listenAddresses = [ machines.${config.networking.hostName}.ip ];

    locations."/" = {
      proxyPass = "http://${config.services.syncthing.guiAddress}";
      recommendedProxySettings = true;
      proxyWebsockets = true;
    };
  };
}
