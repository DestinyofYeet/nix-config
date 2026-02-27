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
    systemd.enable = true;

    settings = {
      settingsVersion = 0;
      bar = {
        barType = "simple";
        position = "top";

        widgets = {
          left = [
            {
              id = "Workspace";
            }
            {
              id = "ActiveWindow";
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
              compactMode = false;
              iconColor = "secondary";
              textColor = "primary";
              usePadding = true;
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
            }
          ];
        };
      };
      location = {
        showWeekNumberInCalender = true;
        weatherEnabled = false;
      };
      dock = {
        enable = false;
      };

      general = {
        showSessionButtonsOnLockScreen = false;
        showHibernateOnLockScreen = false;
        passwordChars = true;
      };

      appLauncher = {
        terminalCommand = "${lib.getExe pkgs.wezterm} -e";
        showIconBackground = true;
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
