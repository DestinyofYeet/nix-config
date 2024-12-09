{
  osConfig,
  lib,
  ...
}:{
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        unlock_cmd = "pkill -USR1 hyprlock";

        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        (lib.mkIf (osConfig.networking.hostName == "wattson") {
            timeout = 30;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
        })
        {
          timeout = 60;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }
      ];
    };
  };  
}
