{
  pkgs,
  lib,
  osConfig,
  ...
}:
{

  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = lib.custom.settings.non-server.background;
    };
  };

  programs.noctalia-shell = {
    enable = true;

    plugins = {
      sources = [
        {
          enabled = true;
          name = "Official Noctalia Plugins";
          url = "https://github.com/noctalia-dev/noctalia-plugins";
        }
      ];

      states = {
        screenshot = {
          enabled = true;
          sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
        };
      };
      version = 2;
    };

    # pluginSettings = { };

    settings = {
      settingsVersion = 0;
      bar = {
        barType = "simple";
        position = "top";
        hideOnOverview = true;

        widgets = {
          left = [
            {
              id = "Workspace";
            }
            {
              id = "ActiveWindow";
              colorizeIcons = false;
            }
            {
              id = "MediaMini";
              textColor = "primary";
            }
          ];
          center = [
            {
              id = "Clock";
              clockColor = "primary";
            }
            {
              id = "plugin:screenshot";
            }
          ];
          right = [
            {
              id = "KeepAwake";
              iconColor = "error";
            }
            {
              id = "Volume";
              displayMode = "alwaysShow";
              iconColor = "secondary";
              textColor = "primary";
            }
            (lib.mkIf (osConfig.capabilities.hardware.keyboardBacklight.enable) {
              id = "Brightness";
              displayMode = "alwaysShow";
              iconColor = "secondary";
              textColor = "primary";
            })
            {
              id = "SystemMonitor";
              compactMode = true;
              iconColor = "secondary";
              textColor = "primary";
              usePadding = true;
            }
            {
              displayMode = "alwaysShow";
              iconColor = "secondary";
              id = "Network";
              textColor = "primary";
            }
            {
              displayMode = "onhover";
              iconColor = "secondary";
              id = "Bluetooth";
              textColor = "primary";
            }

            {
              id = "Battery";
              displayMode = "graphic";
            }
            {
              id = "ControlCenter";
              enableColorization = true;
              colorizeSystemIcon = "error";
              usePadding = true;
            }
            {
              id = "Tray";
              chevronColor = "error";
              pinned = [
                "steam"
              ];
            }
          ];
        };
      };

      location = {
        showWeekNumberInCalendar = true;
        weatherEnabled = false;
        firstDayOfWeek = 1;
      };
      dock = {
        enable = false;
      };

      general = {
        showSessionButtonsOnLockScreen = false;
        showHibernateOnLockScreen = false;
        passwordChars = true;
        lockScreenAnimations = true;
      };

      appLauncher =
        let
          wl-paste = lib.getExe' pkgs.wl-clipboard "wl-paste";
          satty = lib.getExe pkgs.satty;
        in
        {
          terminalCommand = "${lib.getExe pkgs.wezterm} -e";
          showIconBackground = true;
          overviewLayer = true;
          enableClipboardHistory = true;
          clipboardWatchTextCommand = "${wl-paste} --type text --watch cliphist store";
          clipboardWatchImageCommand = "${wl-paste} --type image --watch cliphist store";
          screenshotAnnotationTool = "${satty} -f -";
        };

      nightLight = {
        enabled = false;
        autoSchedule = false;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "07:00";
        manualSunset = "22:00";
      };

      brightness = {
        enableDdcSupport = true;

      };
    };
  };
}
