{
  lib,
  config,
  ...
}:
let
  cfg = config.services.scrutiny.settings.web.listen;
in
{
  services.scrutiny = {
    enable = true;
    settings = {
      web = {
        listen = {
          host = "127.0.0.1";
          port = 2385;
        };
      };
    };
  };

  services.nginx.virtualHosts."smart.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl
    // {
      locations."/" = {
        proxyPass = "http://${cfg.host}:${toString cfg.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
}
