{
  config,
  secretStore,
  lib,
  pkgs,
  ...
}:
let
  secrets = secretStore.getServerSecrets "nix-server";

  dataDir = "/mnt/data/data/readeck";

  user = "readeck";
  group = user;
in
{
  age.secrets = {
    readeck-env-file.file = secrets + "/readeck-env-file.age";
  };

  users = {
    users.${user} = {
      isSystemUser = true;
      group = group;
    };

    groups.${group} = { };
  };

  services.readeck = {
    enable = true;

    environmentFile = config.age.secrets.readeck-env-file.path;

    settings = {
      server = {
        host = "127.0.0.1";
        port = 8723;
        trusted_proxies = [ "127.0.0.1" ];
      };

      main = {
        data_directory = dataDir;

      };

      database = {
        source = "sqlite3:${dataDir}/readeck.sqlite";
      };
    };
  };

  systemd.services.readeck.serviceConfig = {
    DynamicUser = lib.mkForce false;

    User = user;
    Group = group;
  };

  systemd.services.readeck-setup =
    let
      setfacl = (lib.getExe' pkgs.acl "setfacl");
    in
    rec {
      script = ''
        chown ${user}:${group} ${dataDir}
        ${setfacl} -d -m u:${user}:rwx ${dataDir}
        ${setfacl} -m u:${user}:rx /mnt/data/data
        ${setfacl} -m u:${user}:rx /mnt/data
      '';

      requiredBy = [ "readeck.service" ];
      before = requiredBy;
    };

  services.nginx.virtualHosts."archive.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl
    // {
      locations."/" =
        let
          serverSettings = config.services.readeck.settings.server;
        in
        {
          proxyPass = "http://${serverSettings.host}:${toString serverSettings.port}";
          proxyWebsockets = true;
          recommendedProxySettings = true;
        };
    };
}
