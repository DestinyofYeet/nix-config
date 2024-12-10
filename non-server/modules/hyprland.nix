{
  lib,
  pkgs,
  ...
}:
let
  mkWorkSpaceBind = number : workspace : 
    "$mainMod, ${toString number}, workspace, ${toString workspace}";

  mkMoveWorkSpaceBind = number : workspace :
    "$mainMod SHIFT, ${toString number}, movetoworkspace, ${toString workspace}";

  mkGenericWorkSpaceBinds = list : 
    (lib.concatLists (map (number: [ (mkWorkSpaceBind number number) (mkMoveWorkSpaceBind number number) ]) list));

in {
  wayland.windowManager.hyprland = {
    enable = true;

    plugins = with pkgs.hyprlandPlugins; [
      hy3
    ];

    settings = {
      "$mainMod" = "SUPER";
      "$fileManager" = "dolphin";
      "$terminal" = "kitty";
      "$demu" = "${pkgs.rofi-wayland}/bin/rofi -show drun";

      decoration = {
        rounding = 10;
      };

      env = [
        "QT_QPA_PLATFORM,wayland"
        "QT_QPA_PLATFORMTHEME,qt5ct"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "QT_STYLE_OVERRIDE,kvantum"
      ];

      exec-once = [
        "waybar"
        "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"
      ];
    
      input = {
        accel_profile = "flat";

        numlock_by_default = true;

        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };

        tablet = {
          output = "current";
        };

        kb_layout = "de";
      };

      monitor = [
        "eDP-1, 1920x1200@60, 0x0, 1"
      ];

      # dwindle = {
      #   permanent_direction_override = true;
      #   preserve_split = true;
      # };

      general = {
        layout = "hy3";
      };

      bind = [
        "$mainMod SHIFT, m, exit"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, RETURN, exec, $terminal"
        "$mainMod, h, hy3:makegroup, h"
        "$mainMod, v, hy3:makegroup, v"
        "$mainMod SHIFT, q, hy3:killactive"
        "$mainMod, d, exec, $demu"
        "$mainMod, l, exec, loginctl lock-session"
        "$mainMod, f, fullscreen"
        "$mainMod Shift, S, exec, ${pkgs.hyprshot}/bin/hyprshot -m window -m region --clipboard-only"

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
      ]
      ++ (mkGenericWorkSpaceBinds [ 1 2 3 4 5 6 7 8 9 ])
      ;

      bindl = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];
    };
  };
}
