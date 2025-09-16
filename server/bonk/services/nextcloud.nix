{ inputs, secretStore, config, pkgs, lib, ... }:
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

  services.collabora-online = {
    enable = true;
    port = 9980;
    settings = {
      ssl = {
        enable = false;
        termination = true;
      };

      net = {
        proto = "IPv4";
        listen = "loopback";
        post_allow.host = [ "127\\.0\\.0\\.1" ];
      };

      storage.wopi = {
        "@allow" = true;
        host = [ "cloud.ole.blue" ];
      };

      server_name = "collabora.ole.blue";
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
      allow_local_remote_servers = true;
    };

    extraAppsEnable = true;

    # info https://github.com/helsinki-systems/nc4nix
    extraApps = {
      inherit (config.services.nextcloud.package.packages.apps)

        contacts calendar tasks richdocuments;

      # user_oidc = pkgs.fetchNextcloudApp {
      #   appVersion = "7.0.0";
      #   sha256 = "sha256-jhqch6Gup7774P9seExlwhDGbDv0AK9LEzSEtmFW85A=";
      #   url =
      #     "https://github.com/nextcloud-releases/user_oidc/releases/download/v7.0.0/user_oidc-v7.0.0.tar.gz";
      #   license = "agpl3Only";
      # };
    } // {
      inherit (nc4nix.nextcloud-31)
        user_oidc
        # phonetrack
        deck cospend;
    };
  };

  systemd.services.nextcloud-setup.after = [ "postgresql.target" ];

  systemd.services.nextcloud-config-collabora = let
    inherit (config.services.nextcloud) occ;

    wopi_url =
      "http://localhost:${toString config.services.collabora-online.port}";
    public_wopi_url = "https://collabora.ole.blue";
    wopi_allowlist = lib.concatStringsSep "," [ "127.0.0.1" "::1" ];
  in {
    wantedBy = [ "multi-user.target" ];
    after = [ "nextcloud-setup.service" "coolwsd.service" ];
    requires = [ "coolwsd.service" ];
    script = ''
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_url --value ${
        lib.escapeShellArg wopi_url
      }
      ${occ}/bin/nextcloud-occ config:app:set richdocuments public_wopi_url --value ${
        lib.escapeShellArg public_wopi_url
      }
      ${occ}/bin/nextcloud-occ config:app:set richdocuments wopi_allowlist --value ${
        lib.escapeShellArg wopi_allowlist
      }
      ${occ}/bin/nextcloud-occ richdocuments:setup
    '';
    serviceConfig = { Type = "oneshot"; };
  };

  networking.hosts = {
    "127.0.0.1" = [
      config.services.nextcloud.hostName
      config.services.collabora-online.settings.server_name
    ];
    # "::1" = ["nextcloud.example.com" "collabora.example.com"];
  };

  services.nginx.virtualHosts = {
    "${config.services.nextcloud.hostName}" = {
      enableACME = true;
      forceSSL = true;
    };

    "${config.services.collabora-online.settings.server_name}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass =
          "http://localhost:${toString config.services.collabora-online.port}";
        proxyWebsockets = true;

        extraConfig = ''
            # Headers for WebSocket support
          proxy_set_header   Host $host;
          proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header   X-Forwarded-Host $host;
          proxy_set_header   X-Forwarded-Proto $scheme;
          proxy_set_header   Upgrade $http_upgrade;
          proxy_set_header   Connection $http_connection;

        '';
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    samba
    php84Extensions.smbclient
  ];
}
