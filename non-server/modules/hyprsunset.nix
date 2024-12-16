{
  pkgs,
  ...
}:let

  temperature = 3000;

  start-time = "21:00";
  stop-time = "06:00";

in {
  systemd.user = {
    services = {
      hyprsunset-stop = {
        Unit = {
          Conflicts = [ "hyprsunset-start.service" ];
        };

        Service = {
          ExecStart = "echo Stopping";
        };
      };

      hyprsunset-start = {
        Service = {
          ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset -t ${toString temperature}";
        };
      };
    };

    timers = rec {
      hyprsunset-start = {
        Timer = {
          Persistent = true;
          # not needed, is default
          # Unit = [ "hyprsunset-start.service" ];
          OnCalendar = "*-*-* ${start-time}";
        };

        Install = {
          WantedBy = [ "hyprland-session.target" ];
        };
      };

      hyprsunset-stop = {
        Timer = {
          Persistent = true;
          OnCalendar = "*-*-* ${stop-time}";
        };

        inherit (hyprsunset-start) Install;
      };
    };
  };
}
