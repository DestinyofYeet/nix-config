{ config, ... }:{

  services.addReplayGain = {
    enable = true;
    watchDirectory = "${config.serviceSettings.paths.data}/media/navidrome";
    uptimeUrl = "http://192.168.0.248:3001/api/push/JuYmAuAfnH?status=up&msg=OK&ping=";
    inherit (config.serviceSettings) user group;
  };
}
