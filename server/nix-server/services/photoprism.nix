{ secretStore, config, lib, ... }:
let secrets = secretStore.getServerSecrets "nix-server";
in {
  age.secrets = {
    photoprism-admin-pw.file = secrets + "/photoprism-admin.age";
  };

  services.photoprism = {
    enable = true;
    storagePath = "/mnt/data/data/photoprism";
    passwordFile = config.age.secrets.photoprism-admin-pw.path;
    originalsPath = "/mnt/data/data/photos";
    settings = {
      PHOTOPRISM_ADMIN_USER = "admin";
      PHOTOPRISM_DEFAULT_LOCALE = "en";
    };
  };

  systemd.services.photoprism.serviceConfig.User = lib.mkForce "apps";
  systemd.services.photoprism.serviceConfig.Group = lib.mkForce "apps";
  systemd.services.photoprism.serviceConfig.DynamicUser = lib.mkForce false;

  services.nginx.virtualHosts."photos.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl // {
      locations."/" = {
        proxyWebsockets = true;
        proxyPass =
          "http://localhost:${toString config.services.photoprism.port}";
      };
    };
}
