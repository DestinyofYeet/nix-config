{
  apps,
  ...
}:{ 
  systemd.services.add-replay-gain = {
    description = "Automatically add replay gain to files";
    wantedBy = [ "multi-user.target" ];

    inherit (apps.add-replay-gain) enable;

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      ExecStart = "${apps.add-replay-gain.workingDir}/add_replay_gain_to_files";
      WorkingDir = apps.add-replay-gain.workingDir;
      User = apps.user;
      Group = apps.group;
    };
  };
}
