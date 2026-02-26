{
  lib,
  pkgs,
  osConfig,
  ...
}:
let
  lock = "${lib.getExe pkgs.swaylock-effects} --daemonize -C ~/.config/swaylock/config";
  niri = "${lib.getExe' pkgs.niri "niri"}";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  keyboard-backlight = "platform::kbd_backlight";
in
{
  services.swayidle = {
    enable = true;

    systemdTarget = "graphical-session.target";

    timeouts = [
      (lib.custom.mkIfLaptop osConfig {
        timeout = 60;
        command = "${brightnessctl} -sd ${keyboard-backlight} set 0";
        resumeCommand = "${brightnessctl} -rd ${keyboard-backlight}";
      })
      {
        timeout = 90; # needs to be an integer, so 60 * 1.5 does not work
        command = "${brightnessctl} -s set 10";
        resumeCommand = "${brightnessctl} -r";
      }
      {
        timeout = 60 * 3;
        command = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
      }
      {
        timeout = 60 * 5;
        command = "${niri} msg action power-off-monitors";
        resumeCommand = "${niri} msg action power-on-monitors";
      }
    ];

    events = {
      "lock" = lock;
      "before-sleep" = lock;
    };
  };
}
