{ lib, config, pkgs, ... }: let
  dirs = import ./dirs.nix { inherit config;  };

  scripts = import ./scripts.nix { inherit pkgs config; };

  gen-activation = src : dst : ''
      ${pkgs.bash}/bin/bash ${scripts.update-needed-content}/bin/update-needed-content ${src} ${dst}
    '';
in {
  services.kdeconnect = {
    enable = true;
    indicator = false;
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

      cursor = {
        theme = "Posy_Cursor_Black_125_175";
        size = 32;
      };

      splashScreen = {
        theme = "Aretha-Splash-6";
      };
    };
    

    kscreenlocker.appearance = {
      wallpaper = ../../images/wallhaven-lighthouse-snow.jpg;
    };

    input.keyboard = {
      layouts = [
        {
          layout = "de";
        }
      ];
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

    powerdevil.AC = {
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


  home.activation = {

    updateIcons = gen-activation ../needed-content/Icons/BeautySolar "${dirs.home.local.share.icons.path}/BeautySolar";

    updateTheme = gen-activation ../needed-content/Themes/Sweet-Ambar-Blue "${dirs.home.local.share.plasma.desktoptheme.path}/Sweet-Ambar-Blue";

    updateWindowDecors = gen-activation ../needed-content/WindowDecors/Sweet-ambar-blue "${dirs.home.local.share.aurorae.themes.path}/Sweet-ambar-blue";

    updateSplashScreen = gen-activation ../needed-content/Splashscreens/Aretha-Splash-6 "${dirs.home.local.share.plasma.look-and-feel.path}/Aretha-Splash-6";

    updateCursor = gen-activation ../needed-content/Cursors/Posy_Cursor_Black_125_175 "${dirs.home.icons.path}/Posy_Cursor_Black_125_175";

  };
}
