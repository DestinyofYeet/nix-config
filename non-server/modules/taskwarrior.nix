{
  pkgs,
  config,
  secretStore,
  ...
}:
{
  age.secrets = {
    taskwarrior-config.file = secretStore.secrets + /non-server/taskwarrior-config.age;
  };

  programs.taskwarrior = {
    enable = true;

    package = pkgs.taskwarrior3;

    # dataLocation = "/home/ole/Nextcloud/Database/taskwarrior";

    extraConfig = ''
      include ${config.age.secrets.taskwarrior-config.path}
    '';
  };

  systemd.user.services.taskwarrior-sync = {
    Unit = {
      Description = "Taskwarrior sync";
    };
    Service = {
      CPUSchedulingPolicy = "idle";
      IOSchedulingClass = "idle";
      ExecStart = "${config.programs.taskwarrior.package}/bin/task sync";
    };
  };

  systemd.user.timers.taskwarrior-sync = {
    Unit = {
      Description = "Taskwarrior periodic sync";
    };
    Timer = {
      Unit = "taskwarrior-sync.service";
      OnCalendar = "*:0/5";
    };
    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
