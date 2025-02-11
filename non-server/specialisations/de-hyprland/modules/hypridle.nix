{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  locker = "hyprlock";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  keyboard-backlight = "platform::kbd_backlight";
in {
  services.hypridle = {
    enable = true;

    settings = {
      general = {
        lock_cmd = "pidof ${locker} || ${locker}";
        unlock_cmd = "pkill -USR1 ${locker}";

        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        (lib.custom.mkIfLaptop osConfig {
          timeout = 60;
          on-timeout = "${brightnessctl} -sd ${keyboard-backlight} set 0";
          on-resume = "${brightnessctl} -rd ${keyboard-backlight}";
        })
        {
          timeout = 120;
          on-timeout = "${brightnessctl} -s set 10";
          on-resume = "${brightnessctl} -r";
        }
        {
          timeout = 180;
          on-timeout = "loginctl lock-session";
        }
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
      ];
    };
  };
}
