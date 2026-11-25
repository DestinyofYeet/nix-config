{
  pkgs,
  config,
  lib,
  ...
}:
let
  dataDir = "/var/lib/stalwart";
  package = pkgs.stalwart_1;
in
{

  services.nginx.virtualHosts = {
    "mail.musicbot.info" = {
      enableACME = true;
      forceSSL = true;

      locations = {
        "/" = {
          proxyPass = "http://localhost:6852";
        };
      };
    };
  };

  users = {
    users.stalwart = {
      isSystemUser = true;
      group = "stalwart";
    };
    groups.stalwart = { };
  };

  environment.systemPackages = [
    package
    pkgs.stalwart-cli
  ];

  systemd = {
    services.stalwart = {
      description = "Stalwart Server";
      wantedBy = [ "multi-user.target" ];
      after = [
        "local-fs.target"
        "network.target"
      ];

      serviceConfig = {
        # Upstream service config
        Type = "simple";
        LimitNOFILE = 65536;
        KillMode = "process";
        KillSignal = "SIGINT";
        Restart = "on-failure";
        RestartSec = 5;
        SyslogIdentifier = "stalwart";

        ExecStartPre = ''
          ${lib.getExe' pkgs.coreutils "mkdir"} -p ${dataDir}/db
        '';
        ExecStart = [
          "${lib.getExe package} -c ${dataDir}/config"
        ];
        # LoadCredential = lib.mapAttrsToList (key: value: "${key}:${value}") cfg.credentials;

        ReadWritePaths = [
          dataDir
        ];
        CacheDirectory = "stalwart";
        StateDirectory = "stalwart";

        # Upstream uses "stalwart" as the username since 0.12.0
        User = "stalwart";
        Group = "stalwart";

        # Bind standard privileged ports
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

        # Hardening
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateDevices = true;
        PrivateUsers = false; # incompatible with CAP_NET_BIND_SERVICE
        ProcSubset = "pid";
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
