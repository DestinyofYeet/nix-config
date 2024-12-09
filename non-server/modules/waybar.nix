{
  lib,
  ...
}:{
  programs.waybar = {
    enable = true;

    style = lib.mkForce ./waybar-themes/style.css;

    settings = [{
      layer = "top";
      position = "top";
      height = 30;
      spacing = 2;
      # output = [
      #   "eDP-1"
      # ];

      modules-left  = [ "hyprland/workspaces" "wlr/taskbar" ];
      modules-center = [ "clock" ];
      modules-right = [ 
        "battery" 
        "wireplumber"
        "backlight"
        "temperature"
        "group/cpu-load"
        "memory"
        "idle_inhibitor"
        "group/power"
        "bluetooth"
        "network"
        "tray" 
      ];

      "hyprland/workspaces" = {
        format = "{icon}";
        on-scroll-up = "hyprctl dispatch workspace e+1";
        on-scroll-down = "hyprctl dispatch workspace e-1";
      };

      "battery" = {
        format = "{capacity}% {icon} ({power}W)";
        format-icons = [ ""  ""  ""  ""  "" ];
        interval = 20;
      };

      "temperature" = {
        # "thermal-zone" = 2;
        # "hwmon-path" = "/sys/class/hwmon/hwmon2/temp1_input";
        "critical-threshold" = 80;
        # "format-critical" = "{temperatureC}°C {icon}";
        "format" = "{icon} {temperatureC}°C";
        "format-alt" = "{temperatureF}°F {icon}";
        "format-icons" = [ "" "" "" ];
        "tooltip" = false;
        interval = 20;
      };

      "bluetooth" = {
        "format" = " {status}";
        "format-connected" = " {device_alias}";
        "format-connected-battery" = " {device_alias} {device_battery_percentage}%";
        # "format-device-preference": [ "device1", "device2" ], // preference list deciding the displayed device
        "tooltip-format" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
        "tooltip-format-connected" = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
        "tooltip-format-enumerate-connected" = "{device_alias}\t{device_address}";
        "tooltip-format-enumerate-connected-battery" = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
      };

      "memory" = {
        "interval" = 30;
        "format" = " {}%";
        "format-alt" = " {used}G";
        "tooltip" = true;
        "tooltip-format" = "{used:0.1f}G/{total:0.1f}G";
      };

      "backlight" = {
        "device" = "intel_backlight";
        "format" = "{icon} {percent}%";
        "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
        "on-scroll-up" = "brightnessctl set 1%+";
        "on-scroll-down" = "brightnessctl set 1%-";
      };

      "network" = {
        # "interface": "wlp2s0",
        "format" = "{ifname} [󰾆 {bandwidthTotalBytes}]";
        "format-wifi" = "{icon} {essid} [󰾆 {bandwidthTotalBytes}]";
        "format-ethernet" = "󱘖  {ifname} [󰾆 {bandwidthTotalBytes}]";
        "format-disconnected" = "󰌙 Disconnected ⚠";
        "format-alt" = "  {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
        "tooltip-format" = "{ifname} via {gwaddr} ";
        "tooltip-format-wifi" = "{frequency} MHz ({signalStrength}%)";
        "tooltip-format-ethernet" = "{ipaddr}/{cidr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
        "tooltip-format-disconnected" = "Disconnected ⚠";
        "max-length" = 50;
        "format-icons" = [ "󰤯 " "󰤟 " "󰤢 " "󰤢 " "󰤨 " ];
      };

      "clock" = {
        "format-alt" =  "{:%H:%M}";
        "format" = "{:%A, %B %d, %Y (%H:%M)}";
        # //"format" = "<span color='#bf616a'> </span>{:%I:%M %p}";
        # //"format-alt" = "<span color='#bf616a'> </span>{:%A, %B %d, %Y (%I:%M %p)}";
        # // "format" = "{: %R   %d/%m}";
        "tooltip-format" = "<tt><small>{calendar}</small></tt>";
        "calendar" = {
          "mode" = "year";
          "mode-mon-col" = 3;
          "weeks-pos" = "right";
          "on-scroll" = 1;
          "on-click-right" = "mode";
          "format" = {
            "months" = "<span color='#ffead3'><b>{}</b></span>";
            "days" = "<span color='#ecc6d9'><b>{}</b></span>";
            "weeks" = "<span color='#99ffdd'><b>W{}</b></span>";
            "weekdays" = "<span color='#ffcc66'><b>{}</b></span>";
            "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        "actions" = {
          "on-click-right" = "mode";
          "on-click-forward" = "tz_up";
          "on-click-backward" = "tz_down";
          "on-scroll-up" = "shift_up";
          "on-scroll-down" = "shift_down";
        };
      };
    }];
  };
}
