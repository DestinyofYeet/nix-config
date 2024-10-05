{ pkgs, config, ... }:{

  systemd.services.prowlarr = {
    description = "Prowlarr";
    wantedBy = [ "multi-user.target" ];

    enable = true;
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      User = config.serviceSettings.user;
      Group = config.serviceSettings.group;
      ExecStart =
        "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=${config.serviceSettings.paths.configs}/prowlarr";
    };
  };

  services.nginx = let
    default-config = {
      locations."/" = {
        proxyPass = "http://localhost:9696";
        extraConfig = ''
          # Headers for WebSocket support
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        '';
      };
    };
  in {
    
    virtualHosts = {
      "prowlarr.nix-server.infra.wg" = {} // default-config;
      "prowlarr.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-config;
    };
  };
}
