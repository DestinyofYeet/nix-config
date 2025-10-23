{ lib, pkgs, osConfig, config, stable-pkgs, old-pkgs, ... }:
let
  mkWorkSpaceBind = number: workspace:
    "$mainMod, ${toString number}, workspace, ${toString workspace}";

  mkMoveWorkSpaceBind = number: workspace:
    "$mainMod SHIFT, ${toString number}, movetoworkspace, ${
      toString workspace
    }";

  mkGenericWorkSpaceBinds = list:
    (lib.concatLists (map (number: [
      (mkWorkSpaceBind number number)
      (mkMoveWorkSpaceBind number number)
    ]) list));

  monitors_main = {
    tv = "desc:Philips Consumer Electronics Company Philips FTV 0x01010101";
    primary = "desc:Ancor Communications Inc VG248 J5LMQS185620";
    secondary = "desc:Samsung Electric Company C27R50x H1AK500000";
  };

  monitors_laptop = {
    builtin = "eDP-1";
    fsim = {
      table-right = {
        left =
          "desc:Philips Consumer Electronics Company PHL 240B9 AU12220000844";
        right =
          "desc:Philips Consumer Electronics Company PHL 240B9 AU12220000852";
      };

      table-left = {
        left =
          "desc:Philips Consumer Electronics Company PHL 240B9 AU12220000850";
        right =
          "desc:Philips Consumer Electronics Company PHL 240B9 AU12220000842";
      };
    };
    cc_raum = { tv = "desc:WolfVision GmbH Cynap"; };
  };
in {
  wayland.windowManager.hyprland = {
    enable = true;

    package = osConfig.programs.hyprland.package;
    # package = pkgs.hyprland;

    systemd.enableXdgAutostart = true;
    xwayland.enable = true;

    plugins = with pkgs.hyprlandPlugins; [ hy3 hyprgrass ];

    settings = {
      "$mainMod" = "SUPER";
      "$fileManager" = "dolphin";
      "$terminal" = "${lib.getExe pkgs.wezterm}";
      "$dmenu" = "${config.programs.anyrun.package}/bin/anyrun";

      ecosystem = { no_update_news = true; };

      decoration = {
        rounding = 10;

        blur = {
          enabled = true;
          xray = true;
          new_optimizations = true;
          size = 6;
          passes = 3;
          ignore_opacity = true;
          noise = 1.0e-2;
          contrast = 1;
        };
      };

      env = [
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_STYLE_OVERRIDE,kvantum"

        "HYPRCURSOR_THEME,${config.home.pointerCursor.name}"
        "HYPRCURSOR_SIZE,${toString config.home.pointerCursor.size}"
      ];

      exec-once = let
        # wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
        # clipman = "${pkgs.clipman}/bin/clipman";
      in [
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
        # "${wl-paste} --type text --watch ${clipman} store --no-no-persist"
        # "${wl-paste} --type image --watch ${clipman} store --no-no-persist"
      ] ++ (lib.optionals (lib.custom.isMain osConfig) [
        "[workspace 2 silent] ${pkgs.vesktop}/bin/vesktop"
        "${pkgs.noisetorch}/bin/noisetorch -i"
      ]);

      input = {
        accel_profile = "flat";

        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = false;
        };

        tablet = { output = monitors_laptop.builtin; };

        kb_layout = "de";
        kb_options = [ "caps:escape" ];
      };

      device = [ ] ++ (lib.optionals (lib.custom.isMain osConfig) [{
        name = "wlxoverlay-s-keyboard-mouse-hybrid-thing";
        output = "DP-3";
        region_size = "1920, 1080";
        region_position = "960, 540";
        # absolute_region_position = "0, 0";
      }]);

      monitor = [ ] ++ (lib.optionals (lib.custom.isLaptop osConfig) [
        "${monitors_laptop.builtin}, 1920x1200@60, 0x0, 1"
        "${monitors_laptop.cc_raum.tv}, 1920x1080@60hz, 1920x0, 1"

        # fsim
        # "${monitors_laptop.fsim.table-right.left}, preferred, auto, 1"
        # "${monitors_laptop.fsim.table-right.right}, disable"

        # "${monitors_laptop.fsim.table-left.right}, preferred, auto, 1"
        # "${monitors_laptop.fsim.table-left.right}, disable"

        # extends current workspace to other screens
        ", preferred, auto, 1"

        # mirrors current workspace to other screens
        # ", preferred, auto, 1, mirror, ${monitors_laptop.builtin}"
      ]) ++ (lib.optionals (lib.custom.isMain osConfig) [
        "${monitors_main.tv}, disable"
        # "${monitors_main.tv}, 1280x720@60, 0x1080, 1"
        "${monitors_main.primary}, 1920x1080@144, 0x0, 1"
        "${monitors_main.secondary}, 1920x1080@60, 1920x0, 1"
      ]);

      workspace = [ ] ++ (lib.optionals (lib.custom.isMain osConfig) [
        "1, monitor:${monitors_main.primary}, default:true"
        "2, monitor:${monitors_main.secondary}, default:true"
      ]);

      # debug.disable_logs = false;

      general = { layout = "hy3"; };

      bind = let
        # screenshot-cmd = "${pkgs.hyprshot}/bin/hyprshot -m window -m region --clipboard-only";
        inherit (lib.custom.settings) screenshot-cmd;
      in [
        "$mainMod SHIFT, m, exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, h, hy3:makegroup, h"
        "$mainMod, v, hy3:makegroup, v"
        "$mainMod SHIFT, q, hy3:killactive"
        "$mainMod, d, exec, $dmenu"
        "$mainMod, l, exec, loginctl lock-session"
        "$mainMod, f, fullscreen"
        "$mainMod, m, fullscreen, 1"
        "$mainMod Shift, S, exec, ${screenshot-cmd}"
        ", Print, exec, ${screenshot-cmd}"

        "$mainMod SHIFT, h, hy3:movefocus, l"
        "$mainMod SHIFT, j, hy3:movefocus, d"
        "$mainMod SHIFT, k, hy3:movefocus, u"
        "$mainMod SHIFT, l, hy3:movefocus, r"
        "$mainMod, left, hy3:movefocus, l"
        "$mainMod, down, hy3:movefocus, d"
        "$mainMod, up, hy3:movefocus, u"
        "$mainMod, down, hy3:movefocus, r"

        (mkWorkSpaceBind 0 10)
        (mkMoveWorkSpaceBind 0 10)
      ] ++ (mkGenericWorkSpaceBinds [ 1 2 3 4 5 6 7 8 9 ]);

      bindl = let brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
      in [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, ${brightnessctl} s 10%+"
        ",XF86MonBrightnessDown, exec, ${brightnessctl} s 10%-"
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      layerrule = [ "dimaround, rofi" ];

      windowrule = [
        "float,title:^(Open File)(.*)$"
        "float,title:^(File Upload)(.*)$"
        "float,title:^(Select a File)(.*)$"
        "float,title:^(Choose wallpaper)(.*)$"
        "float,title:^(Open Folder)(.*)$"
        "float,title:^(Save As)(.*)$"
        "float,title:^(Library)(.*)$"
        "stayfocused, title:^(Anyrun)(.*)$"
      ];

      animation = [ "workspaces, 0" ];

      plugin = {
        touch_gestures = {
          sensitivity = "1.0";
          workspace_swipe_fingers = "3";
        };
      };
    };
  };
}
