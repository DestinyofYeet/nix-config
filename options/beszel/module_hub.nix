{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.services.beszel_hub;
  defaultWorkingDir = "/var/lib/beszel_hub";
in {
  options = {
    services.beszel_hub = {
      enable = mkEnableOption "to enable the beszel hub";

      host = mkOption {
        description = "The host to bind to";
        default = "127.0.0.1";
        type = types.str;
      };

      port = mkOption {
        description = "The port to bind to";
        default = 8090;
        type = types.port;
      };

      workingDir = mkOption {
        description = "The path to the working directory";
        default = defaultWorkingDir;
        type = types.str;
      };

      user = mkOption {
        description = "The user to run as";
        default = "beszel";
        type = types.str;
      };

      group = mkOption {
        description = "The group to run as";
        default = "beszel";
        type = types.str;
      };

      package = mkOption {
        description = "The package to use";
        default = pkgs.beszel;
        type = types.package;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.beszel_hub = {
      description = "Beszel Hub Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = let port = toString cfg.port;
        in ''
          ${cfg.package}/bin/beszel-hub serve --http "${cfg.host}:${port}"
        '';
        WorkingDirectory = cfg.workingDir;
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = 5;
        StateDirectory =
          mkIf (cfg.workingDir == defaultWorkingDir) "beszel_hub";
      };
    };

    users.users.beszel = {
      enable = (cfg.user == "beszel");
      isSystemUser = true;

      group = cfg.group;
    };

    users.groups = mkIf (cfg.group == "beszel") { beszel = { }; };
  };
}
