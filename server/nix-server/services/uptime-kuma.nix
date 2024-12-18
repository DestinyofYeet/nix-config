{ config, lib, ... }:
{
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
    };
  };

  services.nginx =
    let

      default-conf = {
        locations."/" = {
          proxyPass = "http://localhost:3001";
        };
      };

    in
    {
      virtualHosts = {
        "uptime.local.ole.blue" =
          lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-conf;
      };
    };
}
