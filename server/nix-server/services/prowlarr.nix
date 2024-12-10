{ pkgs, config, lib, ... }:{

  systemd.services.prowlarr = {
    description = "Prowlarr";
    wantedBy = [ "multi-user.target" ];

    enable = true;
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      User = lib.custom.settings.${config.networking.hostName}.user;
      Group = lib.custom.settings.${config.networking.hostName}.group;
      ExecStart =
        "${pkgs.prowlarr}/bin/Prowlarr -nobrowser -data=${lib.custom.settings.${config.networking.hostName}.paths.configs}/prowlarr";
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
      "prowlarr.local.ole.blue" = lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
    };
  };
}
