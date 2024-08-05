{ lib, ... }: {
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.plasma = {
    enable = true;

    overrideConfig = true;

    workspace = {
      clickItemTo = "select";

      wallpaper = ../../images/wallhaven-nightsky.jpg;

      colorScheme = "SweetAmbarBlue";
      theme = "Sweet-Ambar-Blue";
      iconTheme = "BeautySolar";

      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme  = "__aurorae__svg__Sweet-ambar-blue";
      };

      #splashScreen = {
      #  theme = "Aretha-Splash-6";
      #};

      # cursors are broken somehow lol

      # But this doesn't reeee
      # cursor = {
      #   theme = "Posy_Cursor_Black_125_175";
      #   size = 32;
      # }; 
      
      # This shit works
      # cursor = {
      #   theme = "Sweet-cursors";
      #   size = 24;
      # };
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
            icon = "${../../images/nyan_cat_home.png}";
          };
        }
        {
          iconTasks = {
            launchers = [ 
              "applications:firefox.desktop" 
              "applications:org.kde.dolphin.desktop"
              "applications:kitty.desktop"
              "applications:com.github.xournalpp.xournalpp.desktop"
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
                color = "13,0,255";
                label = "CPU Temp";
              }
              {
                name = "power/1451/chargeRate";
                color = "183,0,255";
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
      };

      # disable saving clipboard across DE-Sessions
      klipperrc = {
        "General" = {
          "KeepClipboardContents" = false;
          "MaxClipItems" = 100;
          "IgnoreImages" = false;
        };
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = lib.mkForce "Sweet-Ambar-Blue-Dark-v40";
    };
  };

  home.file = {
    # copy splash screen to path
    #"/home/ole/.local/share/plasma/look-and-feel/Aretha-Splash-6" = {
    #  source = ../needed-content/Aretha-Splashscreen/Aretha-Splash-6;
    #  recursive = true;
    #};

    "/home/ole/.local/share/icons/BeautySolar/" = {
      source = ../needed-content/Icons/BeautySolar;
      recursive = true;
    };
  };
}
