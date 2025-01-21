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

  age.secrets = lib.mkIf config.services.nextcloud.enable {
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
    enable = false;

    package = pkgs.nextcloud30;

    maxUploadSize = "100G";

    enableImagemagick = true;

    hostName = hostname;
    https = true;

    configureRedis = true;

    extraAppsEnable = true;
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps) contacts calendar tasks;
    };

    config = {
      dbhost = "/run/postgresql";
      dbtype = "pgsql";

      dbname = "nextcloud";
      dbuser = "nextcloud";

     adminpassFile = config.age.secrets.nextcloud-admin-pass.path;

      # objectstore.s3 = {
      #   enable = true;
      #   key = "GK9329cf0d4cce8846eec0e796";
      #   hostname = "s3.local.ole.blue";
      #   # hostname = "localhost";
      #   bucket = "nextcloud-bucket";
      #   secretFile = config.age.secrets.nextcloud-bucket-secret-key.path;
      #   usePathStyle = true;
      #   useSsl = true;
      #   # useSsl = false;
      #   # port = 3900;
      #   autocreate = false;
      #   region = "eu-de-south-1";
      # };

    };

    settings = {
      trusted_proxies = [
        "10.100.0.1"
        "127.0.0.1"
      ];

      default_phone_region = "DE";

      # maintenance_window_start = 1;
    };
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl
    // {
      extraConfig = ''
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-NginX-Proxy true;
        proxy_set_header X-Forwarded-Proto http;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_redirect off;
        client_max_body_size ${config.services.nextcloud.maxUploadSize};
      '';
    };
}
