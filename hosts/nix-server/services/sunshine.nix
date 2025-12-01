{ pkgs, ... }: {
  # maybe: https://gist.github.com/Dregu/6a6021bda7108b3e063d05ad7407f914

  # systemd.services."sway-sunshine" = {
  #   description = "Sway Sunshine Headless";

  #   serviceConfig = {
  #     User = "ole";
  #     Group = "users";
  #     PAMName = "login";
  #     TTYPath = "/dev/tty1";
  #     WorkingDirectory = "/home/ole";
  #     Environment = [
  #       "WLR_RENDERER=vulkan"
  #       "WLR_BACKENDS=libinput,headless"
  #       "WLR_LIBINPUT_NO_DEVICES=1"
  #       "XDG_CURRENT_DESKTOP=sway"
  #       "XDG_SESSION_DESKTOP=sway"
  #       "XDG_SESSION_CLASS=user"
  #       "XDG_SESSION_TYPE=wayland"
  #       "XDG_RUNTIME_DIR=/run/user/1000"
  #     ];
  #     # ExecStartPre = ''${pkgs.bash}/bin/sh -c '! "$@"' -- pidof -q sunshine'';
  #     ExecStart = "dbus-run-session sway --unsupported-gpu";
  #   };

  #   wantedBy = [ "multi-user.target" ];
  # };

  # listens on https://{}:47990
  services.sunshine = {
    enable = true;

    autoStart = false;
    capSysAdmin =
      true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };
}
