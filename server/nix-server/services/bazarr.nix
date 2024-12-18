{ config, lib, ... }:
{
  services.bazarr = {
    enable = true;

    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };

  services.nginx =
    let
      default-config = {
        locations."/" = {
          proxyPass = "http://localhost:6767";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };
    in
    {
      virtualHosts = {
        "bazarr.local.ole.blue" =
          lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
      };
    };
}
