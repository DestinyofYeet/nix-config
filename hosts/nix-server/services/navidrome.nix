{
  config,
  pkgs,
  lib,
  ...
}:
{
  services.navidrome = {
    enable = true;
    settings = {
      Port = 4533;
      Address = "0.0.0.0";

      MusicFolder = "${lib.custom.settings.${config.networking.hostName}.paths.data}/media/navidrome";
      DataFolder = "${lib.custom.settings.${config.networking.hostName}.paths.configs}/navidrome";
      FFmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
      EnableSharing = true;
    };

    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };

  services.nginx =
    let
      default-config = {
        locations."/" = {
          proxyPass = "http://localhost:4533";
        };
      };
    in
    {
      virtualHosts = {
        "navidrome.local.ole.blue" =
          lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
      };
    };
}
