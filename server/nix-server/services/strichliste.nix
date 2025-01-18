{
  config,
  lib,
  ...
}:
{
  services.strichliste = {
    enable = true;

    
    nginxSettings = {
      configure = true;
      domain = "strichliste.local.ole.blue";
    };

    # databaseUrl = "mysql://strichliste@localhost/strichliste";

    database.configure = true;

    settings = {
      payment.boundary.upper = 200000;
      account.boundary.upper = 200000;
    };
  };

  
  services.nginx.virtualHosts.${config.services.strichliste.nginxSettings.domain} = lib.custom.settings.${config.networking.hostName}.nginx-local-ssl;

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
