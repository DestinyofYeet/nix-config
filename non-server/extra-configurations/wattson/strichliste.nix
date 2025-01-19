{
  pkgs,
  ...
}:
{
  services.strichliste = {
    enable = true;

    nginxSettings = {
      domain = "strichliste.local";
      configure = true;
    };

    # databaseUrl = "mysql://strichliste@localhost/strichliste";

    database.configure = true;

    settings = {
      payment.boundary.lower = -50000;

      article.autoOpen = true;
    };
  };

  networking.hosts = {
    "127.0.0.1" = [ "strichliste.local" ];
  };

  services.mysql = {
    enable = true;

    ensureUsers = [
      {
        name = "ole";
        ensurePermissions = {
          "ole.*" = "ALL PRIVILEGES";
        };
      }
    ];

    ensureDatabases = [
      "ole"
    ];
  };
}
