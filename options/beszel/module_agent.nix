{ lib, config, pkgs, ... }:
let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.services.beszel_agent;
  defaultWorkingDir = "/var/lib/beszel_agent";
in {
  options = {
    services.beszel_agent = {
      enable = mkEnableOption "to enable the beszel agent";

      publicKey = mkOption {
        description = "The public key for this agent";
        type = types.str;
      };

      host = mkOption {
        description = "The host to bind to";
        default = "0.0.0.0";
        type = types.str;
      };

      port = mkOption {
        description = "The port to bind to";
        default = 45876;
        type = types.port;
      };

      package = mkOption {
        description = "The package to use";
        type = types.package;
        default = pkgs.beszel;
        defaultText = "pkgs.beszel";
      };

      user = mkOption {
        description = "The user to run as";
        default = "beszel-agent";
        type = types.str;
      };

      group = mkOption {
        description = "The group to run as";
        default = "beszel-agent";
        type = types.str;
      };

      workingDir = mkOption {
        description = "The path to the working directory";
        default = defaultWorkingDir;
        type = types.str;
      };

      disks = mkOption {
        description =
          "A list of devices, partitions or mount points to monitor";
        default = [ ];
        type = types.listOf types.str;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.beszel_agent = {
      description = "Beszel Agent Service";
      after = [ "network.target" ];
      wants = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = let port = toString cfg.port;
      in {
        ExecStart = ''
          ${cfg.package}/bin/beszel-agent -listen "${cfg.host}:${port}" -key "${cfg.publicKey}"'';
        Restart = "on-failure";
        RestartSec = 5;
        StateDirectory =
          mkIf (cfg.workingDir == defaultWorkingDir) "beszel_agent";
        User = cfg.user;
        Group = cfg.group;

        Environment =
          [ "EXTRA_FILESYSTEMS=${(builtins.concatStringsSep "," cfg.disks)}" ];

        # DeviceAllow = [ "/dev/nvidiactl rw" "/dev/nvidia0 rw" ];

        # KeyringMode = "private";
        # LockPersonality = "yes";
        # NoNewPrivileges = "yes";
        # ProtectClock = "yes";
        # ProtectHome = "read-only";
        # ProtectHostname = "yes";
        # ProtectKernelLogs = "yes";
        # ProtectSystem = "strict";
        # RemoveIPC = "yes";
        # RestrictSUIDSGID = "true";
      };
    };

    users.users.beszel-agent = {
      enable = (cfg.user == "beszel-agent");
      isSystemUser = true;

      group = cfg.group;
    };

    users.groups = mkIf (cfg.group == "beszel-agent") { beszel-agent = { }; };
  };
}
