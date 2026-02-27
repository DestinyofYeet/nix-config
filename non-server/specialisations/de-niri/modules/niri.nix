{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let

  mkList = string: (lib.flatten (builtins.split " " string));

  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (lib.splitString " " cmd);

  mkSpawnAction = key: action: { "${key}".action.spawn = (mkList action); };
  mkSpawnNoctalia = key: cmd: { "${key}".action.spawn = cmd; };
  mkSpawnActionSh = key: action: { "${key}".action.spawn-sh = action; };
  mkWorkspace = key: workspace: {
    "Mod+${toString key}".action.focus-workspace = workspace;
    "Mod+Shift+${toString key}".action.move-window-to-workspace = [
      { focus = false; }
      (toString key)
    ];
  };
in
{

  programs.niri = {
    enable = true;
    settings = {
      environment = {
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "qt5ct";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_STYLE_OVERRIDE = "kvantum";
      };

      hotkey-overlay = {
        skip-at-startup = true;
      };

      cursor = {
        theme = "Posy_Cursor_Black";
        size = 8;
      };

      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite;
      };

      layout = {
        shadow.color = "#00000000";
        background-color = null;
        focus-ring = {
          enable = false;
        };
      };

      input = {
        keyboard = {
          numlock = true;
          xkb = {
            layout = "de(nodeadkeys)";
            options = "caps:escape";
          };

        };

        mouse = {
          accel-profile = "flat";
        };

        touchpad = {
          dwt = true;
          dwtp = true;

          accel-profile = "flat";
        };

        mod-key = "super";

      };

      binds = lib.mkMerge [
        {
          "Mod+m".action.maximize-column = { };
          "Mod+f".action.fullscreen-window = { };
          "Mod+Shift+q".action.close-window = { };

          "Mod+h".action.focus-column-left = { };
          "Mod+j".action.focus-workspace-down = { };
          "Mod+k".action.focus-workspace-up = { };
          "Mod+l".action.focus-column-right = { };

          "Mod+Shift+h".action.move-column-left-or-to-monitor-left = { };
          "Mod+Shift+j".action.move-window-down-or-to-workspace-down = { };
          "Mod+Shift+k".action.move-window-up-or-to-workspace-up = { };
          "Mod+Shift+l".action.move-column-right-or-to-monitor-right = { };

          "Mod+Ctrl+h".action.focus-monitor-left = { };
          "Mod+Ctrl+l".action.focus-monitor-right = { };

          "Mod+Ctrl+Shift+q".action.quit = { };
        }

        (mkSpawnNoctalia "XF86AudioRaiseVolume" (noctalia "volume increase"))
        (mkSpawnNoctalia "XF86AudioLowerVolume" (noctalia "volume decrease"))
        (mkSpawnNoctalia "XF86AudioMute" (noctalia "volume muteOutput"))
        (mkSpawnNoctalia "XF86AudioMicMute" (noctalia "volume muteInput"))
        (mkSpawnNoctalia "XF86MonBrightnessUp" (noctalia "brightness increase"))
        (mkSpawnNoctalia "XF86MonBrightnessDown" (noctalia "brightness decrease"))
        (mkSpawnNoctalia "XF86AudioPlay" (noctalia "media playPause"))
        (mkSpawnNoctalia "XF86AudioNext" (noctalia "media next"))
        (mkSpawnNoctalia "XF86AudioPrev" (noctalia "media previous"))
        (mkSpawnAction "Mod+Return" "${lib.getExe pkgs.wezterm}")
        (mkSpawnNoctalia "Mod+d" (noctalia "launcher toggle"))
        (mkSpawnAction "Mod+Ctrl+Shift+l" "loginctl lock-session")
        (mkSpawnActionSh "Mod+Shift+S" "${lib.custom.settings.screenshot-cmd}")
        (mkSpawnActionSh "Print" "${lib.custom.settings.screenshot-cmd}")

        (mkWorkspace "1" 1)
        (mkWorkspace "2" 2)
        (mkWorkspace "3" 3)
        (mkWorkspace "4" 4)
        (mkWorkspace "5" 5)
        (mkWorkspace "6" 6)
        (mkWorkspace "7" 7)
        (mkWorkspace "8" 8)
        (mkWorkspace "9" 9)
        (mkWorkspace "0" 10)
      ];

      spawn-at-startup = [
        {
          argv = (mkList "${lib.getExe' pkgs.networkmanagerapplet "nm-applet"} --indicator");
        }
      ]
      ++ (lib.optionals (lib.custom.isMain osConfig) [
        {
          argv = (mkList "${lib.getExe pkgs.vesktop}");
        }
        {
          argv = (mkList "${lib.getExe pkgs.noisetorch} -i");
        }
      ]);

      window-rules = [
        {
          matches = map (id: { app-id = id; }) [
            "tidal-hifi"
            "org.wezfurlong.wezterm"
            "signal"
            "Element"
            "org.keepassxc.KeePassXC"
            "firefox"
          ];

          open-maximized = true;
        }
        {
          matches = [
            {
              app-id = "steam";
              title = ''^notificationtoasts_\d+_desktop$'';
            }
          ];

          default-floating-position = {
            relative-to = "bottom-right";
            x = 10;
            y = 10;
          };

          open-focused = false;
        }
      ]
      ++ lib.optionals (lib.custom.isMain osConfig) [
        {
          matches = [
            {
              app-id = "vesktop";
            }
          ];
          open-on-output = "DP-3";
          open-maximized = true;
        }
      ];

      outputs = lib.mkIf (lib.custom.isMain osConfig) {
        "DP-2" = {
          focus-at-startup = true;
          mode = {
            height = 1080;
            width = 1920;
            refresh = 144.001;
          };
        };
      };
    };
  };
}
