{
  pkgs,
  ...
}:
{
  services.strichliste = {
    enable = true;

    nginxSettings = {
      domain = "localhost";
      configure = true;
    };

    databaseUrl = "mysql://strichliste@localhost/strichliste";

    settings = {
      payment.boundary.lower = -50000;
    };
  };

  services.mysql = {
    enable = true;

    package = pkgs.mariadb;

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
