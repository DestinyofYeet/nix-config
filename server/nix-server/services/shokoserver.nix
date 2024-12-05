{ config, ... }:{
  virtualisation.oci-containers = {
    containers."shokoserver" = {
      image = "shokoanime/server:v5.0.0";
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

  services.nginx = let
    default-config = {
      locations."/" = {
        proxyPass = "http://localhost:8111";
      };
    };
  in {
    virtualHosts = {
      "shoko.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-config;
    };
  };
}
