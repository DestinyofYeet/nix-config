{ inputs, secretStore, config, pkgs, ... }:
let

  nc4nix = import "${inputs.nc4nix}/default.nix" {
    inherit (pkgs) lib recurseIntoAttrs fetchurl runCommand callPackage;
  };
in {
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

    package = pkgs.nextcloud31;

    hostName = "cloud.ole.blue";
    https = true;

    maxUploadSize = "10G";

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

    # info https://github.com/helsinki-systems/nc4nix
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)

        contacts calendar tasks;

      # user_oidc = pkgs.fetchNextcloudApp {
      #   appVersion = "7.0.0";
      #   sha256 = "sha256-jhqch6Gup7774P9seExlwhDGbDv0AK9LEzSEtmFW85A=";
      #   url =
      #     "https://github.com/nextcloud-releases/user_oidc/releases/download/v7.0.0/user_oidc-v7.0.0.tar.gz";
      #   license = "agpl3Only";
      # };
    } // {
      inherit (nc4nix.nextcloud-31) user_oidc phonetrack deck;
    };

  };

  services.nginx.virtualHosts."${config.services.nextcloud.hostName}" = {
    enableACME = true;
    forceSSL = true;
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
    php84Extensions.smbclient
  ];
}
