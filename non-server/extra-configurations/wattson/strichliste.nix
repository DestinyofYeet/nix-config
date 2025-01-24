{pkgs, ...}: {
  services.strichliste = {
    enable = false;

    customSounds = {
      enable = true;
      depositSounds = [
        ./strichliste/spongebob_moneten.wav
      ];

      baselineSounds = [
        ./strichliste/ka-ching.wav
        ./strichliste/mario-coin.wav
      ];

      specificSounds = {
        "1" = {
          sounds = [./strichliste/mate_01.wav];
        };

        "3" = {
          sounds = [./strichliste/wasser_1.wav];
        };

        "4" = {
          sounds = [./strichliste/club_mate_1.wav ./strichliste/mate_01.wav];
        };
      };
    };

    nginxSettings = {
      domain = "strichliste.local";
      configure = true;
    };

    # databaseUrl = "mysql://strichliste@localhost/strichliste";

    database.configure = true;

    settings = {
      payment.boundary.lower = -5000;
      account.boundary.lower = -1000;

      article.autoOpen = true;
    };
  };

  networking.hosts = {
    "127.0.0.1" = ["strichliste.local"];
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
