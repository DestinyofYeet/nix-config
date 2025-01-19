{
  pkgs,
  ...
}:
{
  services.strichliste = {
    enable = true;

    frontEnd = builtins.fetchTarball {
      url = "https://git.ole.blue/ole/strichliste-frontend/raw/commit/6e5f68c0f5f28ff9024ff3af5ef0e64a96b2c948/build.tar";
      sha256 = "1527pdg2y1saj2n13zlnjl8sqcnh3lr702v6x761nag11nagdgqz";
    };

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
