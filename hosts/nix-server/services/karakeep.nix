{
  config,
  lib,
  pkgs,
  secretStore,
  ...
}:
let
  target = "karakeep-init";
  user = config.systemd.services.${target}.serviceConfig.User;

  dataDir = "/mnt/data/data/karakeep";

  setfacl = (lib.getExe' pkgs.acl "setfacl");

  secrets = secretStore.getServerSecrets "nix-server";
in
{
  age.secrets = {
    karakeepEnvFile.file = secrets + "/karakeep-env-file.age";
  };

  services.karakeep = {
    enable = true;
    environmentFile = config.age.secrets.karakeepEnvFile.path;
    extraEnvironment = {
      PORT = "3000";
      ASSETS_DIR = dataDir;

      NEXTAUTH_URL = "https://keep.local.ole.blue";
      DISABLE_NEW_RELEASE_CHECK = "true";
      DB_WAL_MODE = "true";
      DISABLE_PASSWORD_AUTH = "true";

      OAUTH_WELLKNOWN_URL = "https://idp.ole.blue/application/o/karakeep/.well-known/openid-configuration";
      OAUTH_SCOPE = "openid email profile";
      OAUTH_PROVIDER_NAME = "Authentik";
    };
  };

  systemd.services.karakeep-setup = rec {
    script = ''
      chown ${user}:${user} ${dataDir}
      ${setfacl} -d -m u:${user}:rwx ${dataDir}
      ${setfacl} -m u:${user}:rx /mnt/data/data
    '';

    requiredBy = [ "${target}.service" ];
    before = requiredBy;
  };

  services.nginx.virtualHosts."keep.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl
    // {
      locations."/" = {
        proxyPass = "http://localhost:${config.services.karakeep.extraEnvironment.PORT}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
}
