{lib, config, pkgs, ...}:{
  
  with lib;

  let
    cfg = config.services.addReplayGain;
  in {
    options = {
      services.addReplayGain = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable the replay-gain service";
        };

        watch_path = mkOption {
          type = types.str;
          description = "Directory to watch for changes";
        };
      };
    };

    config = mkIf cfg.enable {
      systemd.services.add-replay-gain = {
        description = "Add replay gain to files";
        after = [ "multi-user.target" ];
      };
    };
  };
}
