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

  mkAction =
    {
      key,
      splitString ? false,
      whileLocked ? false,
      ...
    }@settings:
    {
      "${key}" = {
        allow-when-locked = whileLocked;
        action =
          { }
          // (if (builtins.hasAttr "spawn-sh" settings) then { spawn-sh = settings.spawn-sh; } else { })
          // (
            if (builtins.hasAttr "spawn" settings) then
              { spawn = if splitString then mkList (settings.spawn) else settings.spawn; }
            else
              { }
          );
      };
    };

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

      screenshot-path = "/tmp/screenshot_%Y-%m-%d_%H-%M-%S.png";

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

        (mkAction {
          key = "XF86AudioRaiseVolume";
          spawn = (noctalia "volume increase");
          whileLocked = true;
        })
        (mkAction {
          key = "XF86AudioLowerVolume";
          # spawn = (noctalia "volume decrease");
          spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "volume"
            "decrease"
          ];
          whileLocked = true;
        })
        (mkAction {
          key = "XF86AudioMute";
          spawn = (noctalia "volume muteOutput");
          whileLocked = true;
        })
        (mkAction {
          key = "XF86AudioMicMute";
          spawn = (noctalia "volume muteInput");
          whileLocked = true;
        })
        (mkAction {
          key = "XF86AudioPlay";
          spawn = (noctalia "media playPause");
          whileLocked = true;
        })
        (mkAction {
          key = "XF86AudioNext";
          spawn = (noctalia "media next");
          whileLocked = true;
        })
        (mkAction {
          key = "XF86AudioPrev";
          spawn = (noctalia "media previous");
          whileLocked = true;
        })

        (mkAction {
          key = "XF86MonBrightnessUp";
          spawn = (noctalia "brightness increase");
        })

        (mkAction {
          key = "XF86MonBrightnessDown";
          spawn = (noctalia "brightness decrease");
        })

        (mkAction {
          key = "Mod+Return";
          spawn = "${lib.getExe pkgs.wezterm}";
        })

        (mkAction {
          key = "Mod+d";
          spawn = (noctalia "launcher toggle");
        })

        (mkAction {
          key = "Mod+Ctrl+Shift+l";
          spawn = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
          splitString = true;
        })

        {
          "Mod+Shift+S".action.screenshot = {
            show-pointer = false;
          };

          "Print".action.screenshot = {
            show-pointer = false;
          };
        }

        (mkAction {
          key = "Mod+P";
          spawn-sh = "${lib.getExe' pkgs.wl-mirror "wl-mirror"} $(niri msg --json focused-output | ${lib.getExe pkgs.jq} -r .name)";
        })

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
            "nl.jknaapen.fladder"
            "chromium-browser"
          ];

          open-maximized = true;
        }
        {
          matches = [
            {
              app-id = "org.keepassxc.KeePassXC";
              title = "Unlock Database - KeePassXC";
            }
          ];

          open-focused = true;
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
