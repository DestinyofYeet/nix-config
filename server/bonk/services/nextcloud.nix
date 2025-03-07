{ secretStore, config, pkgs, ... }: {
  age.secrets = let secrets = secretStore.get-server-secrets "bonk";
  in {
    bonk-nextcloud-admin-pw = {
      file = secrets + "/nextcloud-root-pw.age";
      owner = "nextcloud";
      group = "nextcloud";
    };
  };

  systemd.services."nextcloud-setup".wants = [ "postgresql.service" ];

  services.nextcloud = {
    enable = true;

    package = pkgs.nextcloud30;

    hostName = "cloud.ole.blue";
    https = true;

    config = {
      dbhost = "/run/postgresql";
      dbname = "nextcloud";
      dbtype = "pgsql";
      dbuser = "nextcloud";

      adminuser = "root";
      adminpassFile = config.age.secrets.bonk-nextcloud-admin-pw.path;
    };

    configureRedis = true;

    settings = {
      trusted_proxies = [ "172.27.255.1" "127.0.0.1" ];

      default_phone_region = "DE";

      maintenance_window_start = 1;

      default_locale = "de_DE";
    };

    extraAppsEnable = true;

    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)

        contacts calendar;
    };

  };

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    enableACME = true;
    forceSSL = true;
  };
}
