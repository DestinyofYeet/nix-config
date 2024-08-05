{ lib, config, pkgs, ... }: let
  dirs = rec {
    home = {
      path = "${config.home.homeDirectory}";
      scripts = {
        path = "${home.path}/scripts";
      };

      icons = {
        path = "${home.path}/.icons";
      };

      local = {
        path = "${home.path}/.local";

        share = {
          path = "${home.local.path}/share";

          icons = {
            path = "${home.local.share.path}/icons";
          };

          aurorae = {
            path = "${home.local.share.path}/aurorae";

            themes = {
              path = "${home.local.share.aurorae.path}/themes";
            };
          };

          plasma = {
            path = "${home.local.share.path}/plasma";

            desktoptheme = {
              path = "${home.local.share.plasma.path}/desktoptheme";
            };

            look-and-feel = {
              path = "${home.local.share.plasma.path}/look-and-feel";
            };
          };
        };
      };
    };
  };
  scripts = {
    update-needed-content = "${dirs.home.scripts.path}/update-needed-content.sh";
  };
in {
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

      cursor = {
        theme = "Posy_Cursor_Black_125_175";
        size = 32;
      };

      splashScreen = {
        theme = "Aretha-Splash-6";
      };

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


  home.activation = {
    updateIcons = ''
      ${pkgs.bash}/bin/bash ${scripts.update-needed-content} ${../needed-content/Icons/BeautySolar} ${dirs.home.local.share.icons.path}/BeautySolar
    '';

    updateTheme = ''
      ${pkgs.bash}/bin/bash ${scripts.update-needed-content} ${../needed-content/Themes/Sweet-Ambar-Blue} ${dirs.home.local.share.plasma.desktoptheme.path}/Sweet-Ambar-Blue
    '';

    updateWindowDecors = ''
      ${pkgs.bash}/bin/bash ${scripts.update-needed-content} ${../needed-content/WindowDecors/Sweet-ambar-blue} ${dirs.home.local.share.aurorae.themes.path}/Sweet-ambar-blue
    '';

    updateSplashScreen = ''
      ${pkgs.bash}/bin/bash ${scripts.update-needed-content} ${../needed-content/Splashscreens/Aretha-Splash-6} ${dirs.home.local.share.plasma.look-and-feel.path}/Aretha-Splash-6
    '';

    updateCursor = ''
      ${pkgs.bash}/bin/bash ${scripts.update-needed-content} ${../needed-content/Cursors/Posy_Cursor_Black_125_175} ${dirs.home.icons.path}/Posy_Cursor_Black_125_175
    '';
  };
}
