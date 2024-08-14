{ config, pkgs, ... }:{
  services.navidrome = {
    enable = true;
    settings = {
      Port = 4533;
      Address = "0.0.0.0";

      MusicFolder = "/data/media/navidrome";
      DataFolder = "/configs/navidrome";
      FFmpegPath = "${pkgs.ffmpeg}/bin/ffmpeg";
      EnableSharing = true; 
    };

    inherit (config.serviceSettings) user group;
  };
}
