{
  pkgs,
  lib,
  config,
  osConfig,
  ...
}:
let
  brightnessctl = "${lib.getExe pkgs.brightnessctl}";
  playerctl = "${lib.getExe pkgs.playerctl}";
  wpctl = "${lib.getExe' pkgs.wireplumber "wpctl"}";

  mkList = string: (lib.flatten (builtins.split " " string));

  mkSpawnAction = key: action: { "${key}".action.spawn = (mkList action); };
  mkSpawnActionL = key: action: {
    "${key}" = {
      action.spawn = (mkList action);
      allow-when-locked = true;
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
          xkb.layout = "de(nodeadkeys)";

        };
        mouse.accel-profile = "flat";

        touchpad = {
          dwt = true;
          dwtp = true;
        };

        mod-key = "super";

      };

      binds = lib.mkMerge [
        {
          "Mod+m".action.maximize-column = { };
          "Mod+f".action.fullscreen-window = { };
          "Mod+Shift+q".action.close-window = { };

          "Mod+h".action.focus-column-left = { };
          "Mod+j".action.focus-window-down = { };
          "Mod+k".action.focus-window-up = { };
          "Mod+l".action.focus-column-right = { };

          "Mod+Shift+h".action.move-column-left-or-to-monitor-left = { };
          "Mod+Shift+j".action.move-window-down-or-to-workspace-down = { };
          "Mod+Shift+k".action.move-window-up-or-to-workspace-up = { };
          "Mod+Shift+l".action.move-column-right-or-to-monitor-right = { };

          "Mod+Ctrl+h".action.focus-monitor-left = { };
          "Mod+Ctrl+l".action.focus-monitor-right = { };

          "Mod+Ctrl+Shift+q".action.quit = { };

        }

        (mkSpawnActionL "XF86AudioRaiseVolume" "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+")
        (mkSpawnActionL "XF86AudioLowerVolume" "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%-")
        (mkSpawnActionL "XF86AudioMute" "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle")
        (mkSpawnActionL "XF86AudioMicMute" "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
        (mkSpawnActionL "XF86MonBrightnessUp" "${brightnessctl} s 10%+")
        (mkSpawnActionL "XF86MonBrightnessDown" "${brightnessctl} s 10%-")
        (mkSpawnActionL "XF86AudioPlay" "${playerctl} play-pause")
        (mkSpawnActionL "XF86AudioNext" "${playerctl} next")
        (mkSpawnActionL "XF86AudioPrev" "${playerctl} previous")
        (mkSpawnAction "Mod+Return" "${lib.getExe pkgs.wezterm}")
        (mkSpawnAction "Mod+d" "${lib.getExe config.programs.anyrun.package}")
        (mkSpawnAction "Mod+Ctrl+Shift+l" "loginctl lock-session")
        (mkSpawnAction "Mod+Shift+S" "${lib.custom.settings.screenshot-cmd}")
        (mkSpawnAction "Print" "${lib.custom.settings.screenshot-cmd}")

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
          matches = [
            {
              app-id = "tidal-hifi";
            }
            {
              app-id = "org.wezfurlong.wezterm";
            }
          ];

          open-maximized = true;
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
