{ config, ... }:{
  services.jellyfin = {
    enable = true;
    dataDir = "/configs/jellyfin";
    inherit (config.serviceSettings) user group;
  };
}
