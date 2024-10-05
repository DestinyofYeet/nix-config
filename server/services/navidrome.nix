{ config, pkgs, ... }:{
  services.navidrome = {
    enable = true;
    settings = {
      Port = 4533;
      Address = "0.0.0.0";

      MusicFolder = "${config.serviceSettings.paths.data}/media/navidrome";
      DataFolder = "${config.serviceSettings.paths.configs}/navidrome";
      FFmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
      EnableSharing = true; 
    };

    inherit (config.serviceSettings) user group;
  };

  services.nginx = let
    default-config = {
      locations."/" = {
        proxyPass = "http://localhost:4533";
      };
    };
  in {
    virtualHosts = {
      "navidrome.nix-server.infra.wg" = {} // default-config;

      "navidrome.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-config;
    };
  };
}
