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
            name = "official";
            kind = "git";
            location = "https://github.com/noctalia-dev/official-plugins";
            auto_update = true;
          }
          {
            name = "community";
            kind = "git";
            location = "https://github.com/noctalia-dev/community-plugins";
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

      osd = {
        kinds = {
          privacy = false;
          media = false;
        };
      };

      idle =
        let

          brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
          keyboard-backlight = "platform::kbd_backlight";
        in
        {
          pre_action_fade_seconds = 0;
          behavior_order = [
            "kb_backlight"
            "dimm_screen"
            "lock"
            "screen_off"
          ];

          behavior = {
            kb_backlight = {
              action = "command";
              timeout = 60;
              command = "${brightnessctl} -sd ${keyboard-backlight} set 0";
              resume_command = "${brightnessctl} -rd ${keyboard-backlight}";
              enabled = true;
            };

            dimm_screen = {
              action = "command";
              timeout = (60 * 1.5);
              command = "${brightnessctl} -s set 10";
              resume_command = "${brightnessctl} -r";
              enabled = true;
            };

            lock = {
              timeout = (60 * 3);
              action = "lock";
              enabled = true;
            };

            screen_off = {
              timeout = (60 * 5);
              action = "screen_off";
              enabled = true;
            };
          };
        };

      widget =
        let
          colors = {
            color = "#00B7C2";
            icon_color = "secondary";
          };
        in
        {

          clock = {
            format = "{:%H:%M %a, %b %d}";
            color = "secondary";
          };

          workspaces = {
            focused_color = "#00BAFF";
            occupied_color = "#9bfece";
            empty_color = "#60639b";
          };

          active_window = {
            title_scroll = "on_hover";
            max_length = 180;

            inherit (colors) color;
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
            display_mode = "graphic";
          }
          // colors;

          bluetooth = { } // colors;

          tray = {
            pinned = [ "steam" ];
            icon_color = "error";

            drawer = true;
            drawer_item_size = 20;
          };

          caffeine = {
            color = "error";
          };

          volume = {
            mute_color = "#787878";
          }
          // colors;

          control-center = {
            icon_color = "error";
          };

          brightness = { } // colors;
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
        auto_locate = false;
      };

      weather = {
        enabled = false;
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
