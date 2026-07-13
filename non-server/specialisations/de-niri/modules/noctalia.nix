{
  pkgs,
  lib,
  config,
  ...
}:
let
  satty = lib.getExe pkgs.satty;

in
{

  home.file.".cache/noctalia/wallpapers.json" = {
    text = builtins.toJSON {
      defaultWallpaper = lib.custom.settings.non-server.background;
    };
  };

  programs.noctalia = {
    enable = true;

    systemd.enable = true;

    settings = {
      plugins = {

        enabled = [ "noctalia/screenshot" ];

        source = [
          {
            name = "Official Noctalia Plugins";
            kind = "git";
            location = "https://github.com/noctalia-dev/noctalia-plugins";
            auto_update = true;
          }
        ];
      };

      wallpaper = {
        enabled = true;
        default.path = lib.custom.settings.non-server.background;
      };

      theme = {
        source = "builtin";
        mode = "dark";
      };

      shell = {
        screenshot = {
          save_to_file = false;
          copy_to_clipboard = false;
          pipe_to_command = true;
          pipe_command = "${satty} -f -";
        };

        show_location = false;
        clipboard_enabled = true;
        clipboard_image_action_command = "${satty} -f -";
        launch_apps_as_systemd_services = config.programs.noctalia.systemd.enable;

        password_style = "random";
        setup_wizard_enabled = false;

      };

      widget =
        let
          colors = {
            color = "primary";
            icon_color = "secondary";
          };
        in
        {
          clock = {
            format = "{:%H:%M %a, %b %d}";
          };

          workspaces = {
            focused_color = "#00BAFF";
            occupied_color = "tertiary";
          };

          active_window = {
            title_scroll = "on_hover";
            max_length = 180;
          };

          sysmon = {
            stat = "cpu_usage";
            label_min_width = 40;
          }
          // colors;

          network = {
            show_label = true;
          }
          // colors;

          battery = {
            displayMode = "graphic";
          };

          tray = {
            pinned = [ "steam" ];
            drawer = true;
            icon_color = "error";
          };

          caffeine = {
            color = "error";
          };

          volume = {
          }
          // colors;

          control-center = {
            icon_color = "error";
          };
        };

      bar = {
        order = [ "main" ];

        main = {
          position = "top";
          layer = "top";
          show_on_workspace_switch = false;
          auto_hide = false;
          margin_ends = 0;

          start = [
            "workspaces"
            "active_window"
            "media"
          ];

          center = [
            "clock"
            # "noctalia/screenshot:screenshot"
          ];

          end = [
            "caffeine"
            "volume"
            "brightness"
            "sysmon"
            "network"
            "bluetooth"
            "battery"
            "control-center"
            "tray"
          ];
        };
      };

      location = {
        auto_locate = true;

        # no replacement found
        # showWeekNumberInCalendar = true;
      };

      notification = {
        enable_daemon = true;
        show_app_name = true;
        show_actions = true;

        position = "top_right";
        layer = "top";
      };

      brightness = {
        enable_ddcutil = true;
      };
    };
  };
}
