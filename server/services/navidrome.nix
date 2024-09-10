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
}
