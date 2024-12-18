{ config, lib, ... }:
{

  age.secrets = {
    airvpn-deluge = {
      file = ../secrets/airvpn-deluge.age;
      path = "/etc/wireguard/wg1.conf";
    };

    deluge-password-file = {
      file = ../secrets/deluge-password-file.age;
    };
  };

  services.deluge = {
    enable = true;
    web.enable = true;
    dataDir = "/mnt/data/configs/deluge";

    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };

  systemd.services.deluged.serviceConfig.NetworkNamespacePath = "/var/run/netns/deluge";

  systemd.services.deluged.serviceConfig.ExecStart =
    lib.mkForce "${config.services.deluge.package}/bin/deluged --do-not-daemonize --config /mnt/data/configs/deluge/.config/deluge --ui-interface 10.1.2.1";

  customLibs.networkNamespaces = {
    enable = true;
    spaces = {
      deluge = {
        enable = true;
        upholdsServices = [ "deluged.service" ];
        networkIpIn = "10.1.2.1";
        networkIpOut = "10.1.2.2";
        wireguardConfigPath = config.age.secrets.airvpn-deluge.path;
        iptableChains = [
          "PREROUTING -p tcp --dport 58846 -j DNAT --to-destination 10.1.2.1:58846"
          "POSTROUTING -j MASQUERADE"
        ];
      };
    };
  };

  services.nginx.virtualHosts = {
    "deluge.local.ole.blue" = lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // {
      locations."/" = {
        proxyPass = "http://localhost:8112";

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
  };

  services.prometheus.exporters.deluge = {
    enable = true;

    delugeHost = "10.1.2.1";

    delugePasswordFile = config.age.secrets.deluge-password-file.path;

    exportPerTorrentMetrics = true;
  };
}
