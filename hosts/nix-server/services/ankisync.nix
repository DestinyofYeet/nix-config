{ config, lib, secretStore, ... }:
let secrets = secretStore.getServerSecrets "nix-server";
in {
  age.secrets = {
    users-ole-password = { file = secrets + "/ankisync-users-ole.age"; };
  };

  services.anki-sync-server = {
    enable = true;
    address = "127.0.0.1";

    users = [{
      username = "ole";
      passwordFile = config.age.secrets.users-ole-password.path;
    }];
  };

  services.nginx.virtualHosts."ankisync.local.ole.blue" =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // {
      locations."/".proxyPass =
        "http://${config.services.anki-sync-server.address}:${
          toString config.services.anki-sync-server.port
        }";
    };
}
