{
  config,
  lib,
  ...
}:
{
  virtualisation.oci-containers = {
    containers."shokoserver" = {
      image = "shokoanime/server:v5.1.0";
      volumes = [
        "${lib.custom.settings.${config.networking.hostName}.paths.configs}/shoko:/home/shoko/.shoko"
        "${lib.custom.settings.${config.networking.hostName}.paths.data}/media/jellyfin/animes:${
          lib.custom.settings.${config.networking.hostName}.paths.data
        }/media/jellyfin/animes"
      ];
      ports = [ "8111:8111" ];
      environment = {
        PUID = "${lib.custom.settings.${config.networking.hostName}.uid}";
        PGID = "${lib.custom.settings.${config.networking.hostName}.gid}";
        TZ = "Europe/Berlin";
      };
    };
  };

  services.nginx =
    let
      default-config = {
        locations."/" = {
          proxyPass = "http://localhost:8111";
        };
      };
    in
    {
      virtualHosts = {
        "shoko.local.ole.blue" =
          lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
      };
    };
}
