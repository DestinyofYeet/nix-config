{ config, ... }: {
  services.mealie = {
    enable = true;
    settings = { ALLOW_SIGNUP = "false"; };
    listenAddress = "127.0.0.1";
  };

  services.nginx.virtualHosts."recipes.ole.blue" = {
    forceSSL = true;
    enableACME = true;

    locations."/".proxyPass = "http://${config.services.mealie.listenAddress}:${
        toString config.services.mealie.port
      }";
  };
}
