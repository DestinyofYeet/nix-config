{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.addReplayGain;
  addReplayGain = pkgs.callPackage ./add-replay-gain-pkg.nix { };
in {
  options = {
    services.addReplayGain = {
      enable = mkEnableOption "add replay gain to files";

      watchDirectory = mkOption {
        type = types.str;
        description = "The directory to watch for new files.";
      };

      metaFlacFlags = mkOption {
        type = types.str;
        default = "--add-replay-gain";
        description = "Flags to add to metaFlac";
      };

      mp3GainFlags = mkOption {
        type = types.str;
        default = "-a -k";
        description = "Flags to add to mp3Gain";
      };

      user = mkOption {
        type = types.str;
        default = "add-replay-gain";
        description = "User to run as";
      };

      group = mkOption {
        type = types.str;
        default = "add-replay-gain";
        description = "Group to run as";
      };

      uptimeUrl = mkOption {
        type = types.str;
        default = null;
        description = "The url to GET every 60 seconds";
      };

      extraSettings = mkOption {
        type = types.lines;
        default = "";
        description = "Additional settings to include in the config.toml.";
      };
    }; };
  config = mkIf cfg.enable {
    systemd.services.add-replay-gain = let 
      config-file = pkgs.writeText "config.toml" ''
        [DEFAULT]
        watch_path = ${cfg.watchDirectory}

        [FLAC]
        metaflac_bin = ${pkgs.flac}/bin/metaflac
        metaflac_flags = ${cfg.metaFlacFlags}

        [MP3]
        mp3gain_bin = ${pkgs.mp3gain}/bin/mp3gain
        mp3gain_flags = ${cfg.mp3GainFlags}

        [UPTIME]
        uptime_url = ${cfg.uptimeUrl}
        '';

    in {
      description = "Add Replay Gain to audio files";
      after = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${addReplayGain}/bin/add_replay_gain_to_files --config ${config-file}";
        Restart = "on-failure";
        User = cfg.user;
        Group = cfg.group;
      };
    };
  };
}
