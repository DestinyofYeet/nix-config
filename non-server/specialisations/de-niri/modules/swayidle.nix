{
  lib,
  pkgs,
  ...
}:
let
  lock = "${lib.getExe pkgs.swaylock-effects} --daemonize -C ~/.config/swaylock/config";
in
{
  services.swayidle = {
    enable = true;

    systemdTarget = "graphical-session.target";

    timeouts = [
      {
        timeout = 60 * 3;
        command = "loginctl lock-session";
      }
    ];

    events = {
      "lock" = lock;
    };
  };
}
