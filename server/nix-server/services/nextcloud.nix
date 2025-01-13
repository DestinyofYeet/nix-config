{
  pkgs,
  config,
  lib,
  ...
}:
let
  hostname = "cloud.local.ole.blue";
in
{

  age.secrets = {
    nextcloud-bucket-secret-key = {
      file = ../secrets/nextcloud-bucket-secret-key.age;
      owner = "nextcloud";
    };

    nextcloud-admin-pass = {
      file = ../secrets/nextcloud-admin-pass.age;
      owner = "nextcloud";
    };
  };

  services.nextcloud = {
    enable = true;

    package = pkgs.nextcloud30;

    hostName = hostname;
    https = true;

    configureRedis = true;

    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
    };

    config = {
      # # dbhost = "localhost";
      dbhost = "/run/postgresql";
      dbtype = "pgsql";

      dbname = "nextcloud";
      dbuser = "nextcloud";
      #
      # dbtype = "sqlite";

      adminpassFile = config.age.secrets.nextcloud-admin-pass.path;

      objectstore.s3 = {
        enable = true;
        key = "GKcf3e40dcbf161ac18889096f";
        # hostname = "s3.local.ole.blue";
        hostname = "localhost";
        bucket = "nextcloud-bucket";
        secretFile = config.age.secrets.nextcloud-bucket-secret-key.path;
        usePathStyle = true;
        # useSsl = true;
        useSsl = false;
        port = 3900;
        autocreate = true;
        region = "eu-de-south-1";
      };
    };

    settings = {
      trusted_proxies = [
        "10.100.0.1"
        "127.0.0.1"
      ];
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl;
}
