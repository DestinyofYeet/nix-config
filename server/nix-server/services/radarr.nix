{ config, lib, ... }: {
  services.radarr = {
    enable = true;

    dataDir = "${
        lib.custom.settings.${config.networking.hostName}.paths.configs
      }/radarr";

    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };

  services.nginx.virtualHosts."radarr.local.ole.blue" =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // {
      locations."/" = {
        proxyPass = "http://localhost:7878";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header   Host $host;
          proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header   X-Forwarded-Host $host;
          proxy_set_header   X-Forwarded-Proto $scheme;
          proxy_set_header   Upgrade $http_upgrade;
          proxy_set_header   Connection $http_connection;

          proxy_redirect     off;

          # needed, otherwise results won't load
          send_timeout 100m;
          proxy_connect_timeout 1800;
          proxy_send_timeout 1800;
          proxy_read_timeout 100m;
        '';
      };
    };
}
