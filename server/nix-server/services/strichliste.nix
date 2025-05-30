{
  config,
  lib,
  ...
}:
{
  services.strichliste = {
    enable = false;

    nginxSettings = {
      configure = true;
      domain = "strichliste.local.ole.blue";
    };

    database.configure = true;

    settings = {
      payment.boundary.upper = 200000;
      account.boundary.upper = 200000;

      article.autoOpen = true;
    };
  };

  services.nginx.virtualHosts.${config.services.strichliste.nginxSettings.domain} =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl
    // {
      locations."/api/metrics" = {
        extraConfig = ''
          deny all;
        '';
      };
    };

  services.mysql = {
    ensureUsers = [
      {
        name = "grafana";
        ensurePermissions = {
          "strichliste.*" = "select";
        };
      }
    ];
  };
}
