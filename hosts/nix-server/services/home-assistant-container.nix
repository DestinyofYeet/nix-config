{
  lib,
  ...
}:
{
  virtualisation.oci-containers.containers.home-assistant = {
    volumes = [ "/mnt/data/data/home-assistant-container:/config" ];
    environment.TZ = "Europe/Berlin";
    image = "ghcr.io/home-assistant/home-assistant:2026.4";

    extraOptions = [
      "--network=host"
      "--privileged"
    ];
  };

  services.nginx.virtualHosts."automation.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl
    // {
      locations."/" = {
        proxyPass = "http://localhost:8123";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
}
