{ config, ... }:{
  services.sonarr = {
    enable = true;
    dataDir = "${config.serviceSettings.paths.configs}/sonarr";

    inherit (config.serviceSettings) user group;
  };

  services.nginx.virtualHosts."sonarr.nix-server.infra.wg" = {
    locations."/" = {
      proxyPass = "http://localhost:8989";
      extraConfig = ''
        # Headers for WebSocket support
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
      '';
    };
  };
}
