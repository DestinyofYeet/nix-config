{ config, lib, ... }:
{

  services.addReplayGain = {
    enable = true;
    watchDirectory = "${lib.custom.settings.${config.networking.hostName}.paths.data}/media/navidrome";
    uptimeUrl = "http://127.0.0.1:3001/api/push/0Ehx7iOnZ0?status=up&msg=OK&ping=";
    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };
}
