{ stable-pkgs, config, lib, ... }:{

  # needed for sonarr
  nixpkgs.config.permittedInsecurePackages = [
    "aspnetcore-runtime-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "dotnet-sdk-6.0.428"
    "dotnet-sdk-wrapped-6.0.428"
  ];

  services.sonarr = {
    enable = true;
    dataDir = "${lib.custom.settings.${config.networking.hostName}.paths.configs}/sonarr";

    # package = stable-pkgs.sonarr;

    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };

  services.nginx = let 
    default-config = {
      locations."/" = {
        proxyPass = "http://localhost:8989";
        extraConfig = ''
          # Headers for WebSocket support
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
  in {
    
    virtualHosts = { 
      "sonarr.nix-server.infra.wg" = {} // default-config;
      "sonarr.local.ole.blue" = lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
    };
  };
}
