{ ... }: {

  programs.plasma = {
    enable = true;

    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
      theme = "breeze-dark";
      lookAndFeel = "org.kde.breezedark.desktop";
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
    ];

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
  };
}
