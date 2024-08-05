{ lib, ... }: {
  programs.plasma = {
    enable = true;

    overrideConfig = true;

    workspace = {
      clickItemTo = "select";

      wallpaper = ../../images/wallhaven-nightsky.jpg;

      colorScheme = "BreezeDark";
      theme = "breeze-dark";
      iconTheme = "BeautySolar";

      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme  = "__aurorae__svg__Sweet-ambar-blue";
      };

      cursor = {
        theme = "Posy's Cursor Black [Posy_Cursor_Black]";
        size = 32;
      };
    };
    

    kscreenlocker = {
      wallpaper = ../../images/wallhaven-lighthouse-snow.jpg;
    };

    input.keyboard = {
      layouts = [ "de" ];
      numlockOnStartup = "on";
    };

    input.touchpads = [
      {
        enable = true;
        disableWhileTyping = true;
        name = "SynPS/2 Synaptics TouchPad"; # touchpad of kartoffelkiste (alt)
        tapToClick = true;
        naturalScroll = true;
        vendorId = "0002";
        productId = "0007";
      }
      {
        enable = true;
        disableWhileTyping = true;
        name = "ELAN06FA:00 04F3:3293 Touchpad"; # touchpad of wattson
        tapToClick = true;
        pointerSpeed = 0;
        naturalScroll = true;
        vendorId = "04f3";
        productId = "3293";
      }
    ];


    panels = [{
      location = "bottom";
      height = 48;
      widgets = [
        {
          kickoff = {
            sortAlphabetically = true;
            compactDisplayStyle = true;
            icon = "nix-snowflake-white";
          };
        }
        {
          iconTasks = {
            launchers = [ 
              "applications:firefox.desktop" 
              "applications:org.kde.dolphin.desktop"
              "applications:kitty.desktop"
            ];
          };
        }

        {  
          systemMonitor = {
            showLegend = false;
            displayStyle = "org.kde.ksysguard.textonly";
            sensors = [ 
              {
                name = "cpu/all/averageTemperature";
                color = "255,255,255";
                label = "CPU";
              }
              {
                name = "power/1451/chargeRate";
                color = "0,0,0";
                label = "Charging Rate";
              }
            ];
          };
        }

        "org.kde.plasma.marginsseparator"

        {
          systemTray.items = {
            shown = [
              "org.kde.plasma.battery"
              "org.kde.plasma.bluetooth"
              "org.kde.plasma.volume"
            ];
          };
        }
        {
          digitalClock = {
            calendar.firstDayOfWeek = "monday";
            time.format = "24h";
          };
        }
      ];
    }];

    powerdevil = {
      powerButtonAction = "lockScreen";
      turnOffDisplay = {
        idleTimeout = 1000;
        idleTimeoutWhenLocked = "immediately";
      };
    };

    kwin = {
      edgeBarrier = 0;
      cornerBarrier = false;
      effects.blur.enable = true;
      titlebarButtons = {
        left = [
          "close"
          "maximize"
          "minimize"
        ];

        right = [];
      };
    };

    configFile = {
      # makes the default border edge action dissapear
      kwinrc = {
        "Effect-overview"."BorderActivate" = 9;
        #"org.kde.kdecoration2" = {
        #  "library" = "org.kde.kwin.aurorae";
        #  "theme" = "__aurorae__svg__Carl";
        #};
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Sweet-Ambar-Blue-Dark-v40";
    };
  };
}
