{ pkgs, config, ... }:
let
  namespace = "qbit";

  qbit = {
    dataDir = "${config.serviceSettings.paths.configs}";
    enable = true;
  };
in {

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
      NetworkNamespacePath="/var/run/netns/${namespace}";
      User = config.serviceSettings.user;
      Group = config.serviceSettings.group;
      ExecStart =
        "${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --profile=${qbit.dataDir}";

      TimeoutStopSec = 30; # takes the full 90 seconds when trying to stop this service, dunno why
    };
  };

  services.nginx = let
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
  in {
    virtualHosts = {
      "qbittorrent.nix-server.infra.wg" = {} // default-config;

      "qbittorrent.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-config;
    };
  };

  # virtualisation.oci-containers.containers."prometheus-qbittorrent-exporter" = {
  #   image = "ghcr.io/esanchezm/prometheus-qbittorrent-exporter";

  #   ports = [
  #     "8000:8000"
  #   ];

  #   environment = {
  #     QBITTORRENT_HOST = "10.1.1.1";
  #     QBITTORRENT_PORT = "8080";
  #     # QBITTORRENT_SSL = "True";
  #   };

  #   environmentFiles = [
  #     config.age.secrets.qbit-prometheus-exporter.path
  #   ];
  # };

  # virtualisation.oci-containers.containers."qbittorrent-prometheus-exporter" = {
  #   image = "ghcr.io/martabal/qbittorrent-exporter:latest";

  #   ports = [
  #     "8090:8090"
  #   ];

  #   environmentFiles = [
  #     config.age.secrets.qbit-prometheus-exporter.path
  #   ];
  # };

  services.qbittorrent-prometheus-exporter = {
    enable = false;

    envFile = config.age.secrets.qbit-prometheus-exporter.path;
  };
}
