{ lib, config, pkgs, ... }:

with lib;

let
  cfg = config.services.cleanUnusedFiles;
  pkg = pkgs.callPackage ./pkg.nix { };
in {
  options = {
    services.cleanUnusedFiles = {
      enable = mkEnableOption "cleaning of unused files";

      qbit = {
        url = mkOption {
          type = types.str;
          description = "The url to Qbit";
        };

        user = mkOption {
          type = types.str;
          description = "The user to authenticate as";
        };

        password = mkOption {
          type = types.str;
          description = "The password for the user";
        };
      };

      email = {
        server = mkOption {
          type = types.str;
          description = "The email server to use";
        };

        user = mkOption {
          type = types.str;
          description = "The user to send the email as";
        };

        password = mkOption {
          type = types.str;
          description = "The password for the user";
        };

        recipient = mkOption {
          type = types.str;
          description = "The recipient of the email";
        };
      };

      dataFile = mkOption {
        type = types.str;
        description = "The path to the datafile";
      };

      user = mkOption {
        type = types.str;
        description = "The user to run the service as";
      };

      group = mkOption {
        type = types.str;
        description = "The group to run the service as";
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = "Additional settings to include in the config.toml.";
      };
    }; 
  };

  config = mkIf cfg.enable {
    systemd.services.cleanUnusedFiles = let 
      configFile = pkgs.writeText "config.toml" ''
        [QBIT]
        url = ${cfg.qbit.url}
        user = ${cfg.qbit.user}
        password = ${cfg.qbit.password}

        [EMAIL]
        server = ${cfg.email.server}
        user = ${cfg.email.user}
        password = ${cfg.email.password}
        recipient = ${cfg.email.recipient}

        ${cfg.extraConfig}
        '';

    in {
      description = "Clean qbittorrent of unused files";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkg}/bin/clean_unused_files --config-file ${configFile} --data-file ${cfg.dataFile}";
        User = cfg.user;
        Group = cfg.group;
      };
    };

    systemd.timers.cleanUnusedFiles = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
      };
    }; 
  };
}
