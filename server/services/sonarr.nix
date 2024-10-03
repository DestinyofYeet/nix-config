{ config, ... }:{
  services.sonarr = {
    enable = true;
    dataDir = "${config.serviceSettings.paths.configs}/sonarr";

    inherit (config.serviceSettings) user group;
  };

  # services.nginx.virtualHosts."sonarr.nix-server.infra.wg" = {
  #   locations."/" = {
  #     proxyPass = "http://localhost:8989";
  #   };
  # };
}
