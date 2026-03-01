{
  lib,
  ...
}:
{
  services.music-assistant = {
    enable = true;
    providers = [
      "opensubsonic"
      "sendspin"
      "snapcast"
      "tidal"
      "squeezelite"
    ];
  };

  services.nginx.virtualHosts."music.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl
    // {
      locations."/" = {
        proxyPass = "http://localhost:8095";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };

}
