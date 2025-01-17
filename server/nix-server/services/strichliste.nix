{
  config,
  ...
}:
{
  services.strichliste = {
    enable = true;

    
    nginxSettings = {
      configure = true;
      domain = "strichliste.local.ole.blue";
    };

    databaseUrl = "mysql://strichliste@localhost/strichliste";

    settings = {
      payment.boundary.upper = 200000;
      account.boundary.upper = 200000;
    };
  };

  
  services.nginx.virtualHosts.${config.services.strichliste.nginxSettings.domain} = {
    forceSSL = true;
    enableACME = true;
  };

  services.mysql = {

    ensureUsers = [
      {
        name = "strichliste";
        ensurePermissions = {
          "strichliste.*" = "ALL PRIVILEGES";
        };
      }
    ];

    ensureDatabases = [
      "strichliste"
    ];
  };
}
