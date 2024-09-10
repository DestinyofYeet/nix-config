{ config, ... }:{
  virtualisation.oci-containers = {
    containers."shokoserver" = {
      image = "shokoanime/server";
      volumes = [
        "${config.serviceSettings.paths.configs}/shoko:/home/shoko/.shoko"
        "${config.serviceSettings.paths.data}/media/jellyfin/animes:${config.serviceSettings.paths.data}/media/jellyfin/animes"
      ];
      ports = [ "8111:8111" ];
      environment = {
        PUID = "${config.serviceSettings.uid}";
        PGID = "${config.serviceSettings.gid}";
        TZ = "Europe/Berlin";
      };
    };
  };
}
