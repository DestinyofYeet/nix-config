{
  lib,
  pkgs,
  osConfig,
  config,
  inputs,
  ...
}:
let
  lock = "${lib.getExe' pkgs.systemd "loginctl"} lock-session";
  niri = "${lib.getExe' pkgs.niri "niri"}";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  keyboard-backlight = "platform::kbd_backlight";
in
lib.mkIf (!config.programs.noctalia.enable) {
  services.swayidle = {
    enable = true;

    systemdTargets = [ "graphical-session.target" ];

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
        command = lock;
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
