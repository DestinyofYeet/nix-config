{
  lib,
  config,
  osConfig,
  ...
}:
let
  dirs = import ../../../modules/dirs.nix { inherit config; };
in
{
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    kscreenlocker = {
      appearance.wallpaper = lib.custom.settings.non-server.lock-screen;
      autoLock = true;
      lockOnResume = true;
      passwordRequired = true;
      passwordRequiredDelay = 5;
      timeout = 5;
    };

    spectacle = {
      shortcuts = {
        captureRectangularRegion = "Meta+Shift+S";
      };
    };

    workspace = {
      clickItemTo = "select";

      wallpaper = lib.custom.settings.non-server.background;

      colorScheme = "";
      theme = "Sweet-Ambar-Blue";
      iconTheme = "BeautySolar";

      windowDecorations = {
        library = "org.kde.kwin.aurorae";
        theme = "__aurorae__svg__Sweet-ambar-blue";
      };

      cursor = {
        theme = "Posy_Cursor_Black_125_175";
        size = 32;
      };

      splashScreen = {
        theme = "Aretha-Splash-6";
      };
    };

    input.keyboard = {
      layouts = [ { layout = "de"; } ];
      numlockOnStartup = "on";
    };

    input.mice = [
      {
        enable = true;
        accelerationProfile = "none";
        acceleration = -0.18;
        name = "Logitech Gaming Mouse G502";
        vendorId = "046d";
        productId = "c332";
      }
    ];

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

    panels = [
      {
        location = "bottom";
        height = 48;
        screen = "all";
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              compactDisplayStyle = true;
              icon = "${../../../../images/nyan_cat_home.png}";
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:firefox.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:kitty.desktop"
                "applications:com.github.xournalpp.xournalpp.desktop"
                "applications:org.kde.spectacle.desktop"
              ];
            };
          }

          (lib.mkIf (osConfig.networking.hostName == "wattson") {
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
          })

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
      }
    ];

    powerdevil.AC = {
      powerButtonAction = "lockScreen";
      turnOffDisplay = {
        idleTimeout = 1000;
        idleTimeoutWhenLocked = "immediately";
      };

      autoSuspend = {
        action = "nothing";
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

        right = [ ];
      };

      nightLight = {
        enable = true;

        mode = "times";
        temperature = {
          day = 6500;
          night = 3500;
        };

        time = {
          # start
          evening = "22:00";

          # stop
          morning = "06:00";
        };

        transitionTime = 10;
      };
    };

    configFile = {
      # makes the default border edge action dissapear
      kwinrc = {
        "Effect-overview"."BorderActivate" = 9;

        # virtual keyboard
        "Wayland" = lib.mkIf (osConfig.networking.hostName == "wattson") {
          "InputMethod" = "/run/current-system/sw/share/applications/com.github.maliit.keyboard.desktop";
          "VirtualKeyboardEnabled" = false;
        };
      };

      # disable saving clipboard across DE-Sessions
      klipperrc = {
        "General" = {
          "KeepClipboardContents" = false;
          "MaxClipItems" = 100;
          "IgnoreImages" = false;
        };
      };

      ksmserverrc = {
        "General" = {
          "loginMode" = "emptySession";
        };
      };

      plasmaparc = {
        "General" = {
          "RaiseMaximumVolume" = true;
        };
      };
    };
  };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = lib.mkForce "adw-gtk3-dark";
  #   };
  # };

  home.activation =
    let
      inherit (lib.custom) gen-activation gen-activation-file;
    in
    {

      updateIcons = gen-activation ./needed-content/Icons/BeautySolar "${dirs.home.local.share.icons.path}/BeautySolar";

      updateTheme = gen-activation ./needed-content/Themes/Sweet-Ambar-Blue "${dirs.home.local.share.plasma.desktoptheme.path}/Sweet-Ambar-Blue";

      updateWindowDecors = gen-activation ./needed-content/WindowDecors/Sweet-ambar-blue "${dirs.home.local.share.aurorae.themes.path}/Sweet-ambar-blue";

      updateSplashScreen = gen-activation ./needed-content/Splashscreens/Aretha-Splash-6 "${dirs.home.local.share.plasma.look-and-feel.path}/Aretha-Splash-6";

      updateCursor = gen-activation ./needed-content/Cursors/Posy_Cursor_Black_125_175 "${dirs.home.icons.path}/Posy_Cursor_Black_125_175";

      updateColorSchemes = gen-activation-file ./needed-content/color-schemes/SweetAmbarBlue.colors "${dirs.home.local.share.color-schemes.path}/SweetAmbarBlue.colors";

    };
}
