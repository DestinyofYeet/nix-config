{ config, ... }:{
  services.sonarr = {
    enable = true;
    dataDir = "${config.serviceSettings.paths.configs}/sonarr";

    inherit (config.serviceSettings) user group;
  };
}
