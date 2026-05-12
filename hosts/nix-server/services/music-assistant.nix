{
  config,
  lib,
  ...
}:
{
  services.music-assistant = {
    enable = true;
    # providers = [
    #   "opensubsonic"
    #   "sendspin"
    #   "snapcast"
    #   "tidal"
    #   "squeezelite"
    #   "hass"
    #   "hass_players"
    #   "ytmusic"
    #   "universal_group"
    #   "builtin"
    #   "airplay"
    #   "airplay_receiver"
    #   "bluesound"
    # ];
    providers = builtins.filter (
      elem:
      !(builtins.elem elem [
        # blacklist some provider here
      ])
    ) config.services.music-assistant.package.providerNames;
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
