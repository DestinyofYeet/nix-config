{ pkgs, ... }: {

  home.stateVersion = "24.05";

  programs.vim = {
    enable = true;
    extraConfig = ''
      set tabstop=2
      set number
      '';
  };

  programs.plasma = {
    enable = true;

    panels = [{
      location = "bottom";
      widgets = [
        {
          kickoff = {
            sortAlphabetically = true;
            icon = "nix-snowflake-white";
          };
        }
        {
          iconTasks = {
            launchers = [ 
              "applications:firefox.desktop" 
              "applications:org.kde.dolphin.desktop"
              "applications:org.kde.konsole.desktop"
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
      # cornerBarier = false;
    };
  };

  # Optionally, use home-manager.extraSpecialArgs to pass
  # arguments to home.nix
}
