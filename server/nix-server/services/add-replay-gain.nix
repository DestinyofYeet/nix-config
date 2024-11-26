{ config, ... }:{

  services.addReplayGain = {
    enable = true;
    watchDirectory = "${config.serviceSettings.paths.data}/media/navidrome";
    uptimeUrl = "http://127.0.0.1:3001/api/push/0Ehx7iOnZ0?status=up&msg=OK&ping=";
    inherit (config.serviceSettings) user group;
  };
}
