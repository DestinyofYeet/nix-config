{ lib, ... }:
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
            }
          ];
          center = [
            {
              id = "Clock";
            }
          ];
          right = [
            {
              id = "KeepAwake";
            }
            {
              id = "Volume";
            }
            {
              id = "Brightness";
            }
            {
              id = "SystemMonitor";
            }
            {
              id = "Battery";
              displayMode = "graphic";
            }
            {
              id = "ControlCenter";
            }
            {
              id = "Tray";
            }
          ];
        };
      };
      location = {
        name = "Regensburg, DE";
        showWeekNumberInCalender = true;
      };

      general = {
        showSessionButtonsOnLockScreen = false;
        showHibernateOnLockScreen = false;

      };
    };
  };
}
