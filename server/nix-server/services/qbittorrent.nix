{
  pkgs,
  config,
  lib,
  ...
}:
let
  namespace = "qbit";

  qbit = {
    dataDir = "${lib.custom.settings.${config.networking.hostName}.paths.configs}";
    enable = true;
  };
in
{

  age.secrets = {
    airvpn-config = {
      file = ../secrets/airvpn_config.age;
      path = "/etc/wireguard/wg0.conf";
    };

    qbit-prometheus-exporter = {
      file = ../secrets/qbit-prometheus-exporter.age;
    };
  };

  customLibs.networkNamespaces = {
    enable = true;
    spaces = {
      ${namespace} = {
        enable = true;
        upholdsServices = [ "qbittorrent-nox.service" ];
        networkIpIn = "10.1.1.1";
        networkIpOut = "10.1.1.2";
        wireguardConfigPath = config.age.secrets.airvpn-config.path;
      };
    };
  };

  systemd.services.qbittorrent-nox = {
    description = "Run Qbittorrent-nox";
    wantedBy = [ "multi-user.target" ];
    requires = [ "namespace-${namespace}.service" ];

    partOf = [ "namespace-${namespace}.service" ]; # qbit stops if the vpn-namespace service stops

    enable = qbit.enable;
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      NetworkNamespacePath = "/var/run/netns/${namespace}";
      User = lib.custom.settings.${config.networking.hostName}.user;
      Group = lib.custom.settings.${config.networking.hostName}.group;
      ExecStart = "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=${qbit.dataDir}";

      TimeoutStopSec = 30; # takes the full 90 seconds when trying to stop this service, dunno why
    };
  };

  services.nginx =
    let
      default-config = {
        locations."/" = {
          proxyPass = "http://10.1.1.1:8080";
          extraConfig = ''
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;

            # Prevent gzip encoding issues
            proxy_set_header Accept-Encoding "";

            # If necessary, disable buffer to get immediate response from upstream
            proxy_buffering off;
          '';
        };
      };
    in
    {
      virtualHosts = {
        "qbittorrent.nix-server.infra.wg" = { } // default-config;

        "qbittorrent.local.ole.blue" =
          lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
      };
    };

  services.qbittorrent-prometheus-exporter = {
    enable = true;

    envFile = config.age.secrets.qbit-prometheus-exporter.path;
  };
}
