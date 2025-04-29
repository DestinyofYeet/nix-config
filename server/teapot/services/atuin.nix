{ config, ... }: {
  services.atuin = {
    enable = true;
    openRegistration = false;
  };

  services.nginx.virtualHosts."atuin.ole.blue" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = let cfg = config.services.atuin;
    in { proxyPass = "http://${cfg.host}:${toString cfg.port}"; };
  };
}
