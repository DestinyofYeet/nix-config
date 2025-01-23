{pkgs, ...}: {
  services.strichliste = {
    enable = false;

    # frontEnd = builtins.fetchTarball {
    #   url = "https://git.ole.blue/ole/strichliste-frontend/raw/commit/6e5f68c0f5f28ff9024ff3af5ef0e64a96b2c948/build.tar";
    #   sha256 = "1527pdg2y1saj2n13zlnjl8sqcnh3lr702v6x761nag11nagdgqz";
    # };
    #

    customSounds = {
      enable = true;
      depositSounds = [
        ./strichliste/spongebob_moneten.wav
      ];

      baselineSounds = [
        ./strichliste/ka-ching.wav
        ./strichliste/mario-coin.wav
      ];

      specificSounds = [
        {
          # Mio Mio Mate
          id = 1;
          sounds = [
            ./strichliste/mate_01.wav
          ];
        }
        {
          # Wasser
          id = 3;
          sounds = [
            ./strichliste/wasser_1.wav
          ];
        }
        {
          # Club mate
          id = 4;
          sounds = [
            # ./strichliste/club_mate_1.wav
            ./strichliste/mate_01.wav
          ];
        }
        {
          # Saftschorle
          id = 6;
          sounds = [
            ./strichliste/moneyboy_orangensaft.wav
          ];
        }
        {
          # Bueno
          id = 9;
          sounds = [
            ./strichliste/bueno_1.wav
          ];
        }
        {
          # Erdnüsse klein
          id = 12;
          sounds = [
            ./strichliste/eier.wav
          ];
        }
        {
          # Belaste
          id = 14;
          sounds = [
            ./strichliste/emotional-damage.wav
          ];
        }
        {
          # Snickers
          id = 16;
          sounds = [
            ./strichliste/snickers_1.wav
          ];
        }
        {
          # Maoam
          id = 19;
          sounds = [
            ./strichliste/maoam_1.wav
          ];
        }
        {
          # Mentos
          id = 20;
          sounds = [
            ./strichliste/eier.wav
          ];
        }
        {
          # Spezi
          id = 23;
          sounds = [
            ./strichliste/spezifische_spezi_fischer.wav
          ];
        }
        {
          # Kaffee
          id = 24;
          sounds = [
            ./strichliste/coffee.wav
            ./strichliste/coffee_2.wav
            ./strichliste/coffee_3.wav
          ];
        }
        {
          # Pizza
          id = 25;
          sounds = [
            ./strichliste/pizza_1.wav
          ];
        }
        {
          # Radler
          id = 27;
          sounds = [
            ./strichliste/radler.wav
          ];
        }
        {
          # Mio Mio Banane
          id = 28;
          sounds = [
            ./strichliste/minion_banana.wav
            ./strichliste/mio_mio_banana_2.wav
          ];
        }
        {
          # Duplo
          id = 30;
          sounds = [
            ./strichliste/duplo_1.wav
            ./strichliste/duplo_2.wav
          ];
        }
      ];
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
