{
  config,
  ...
}:{
  services.radarr = {
    enable = true;

    dataDir = "${config.serviceSettings.paths.configs}/radarr";

    inherit (config.serviceSettings) user group;
  };

  services.nginx.virtualHosts."radarr.local.ole.blue" = config.serviceSettings.nginx-local-ssl // {
    locations."/" = {
      proxyPass = "http://localhost:7878";
      extraConfig = ''
        proxy_set_header   Host $host;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Host $host;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_set_header   Upgrade $http_upgrade;
        proxy_set_header   Connection $http_connection;

        proxy_redirect     off;
        proxy_http_version 1.1;
      '';
    };
  };
}
