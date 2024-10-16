{
  config,
  lib,
  ...
}:{

  config.age.secrets = {
    airvpn-deluge = {
      file = ../secrets/airvpn-deluge.age;
      path = "/etc/wireguard/wg1.conf";
    };
  };

  config.services.deluge = {
    enable = true;
    web.enable = true;
    dataDir = "/mnt/data/configs/deluge";

    inherit (config.serviceSettings) user group;
  };

  config.systemd.services.deluged.serviceConfig.NetworkNamespacePath = "/var/run/netns/deluge";

  config.systemd.services.deluged.serviceConfig.ExecStart = lib.mkForce "${config.services.deluge.package}/bin/deluged --do-not-daemonize --config /mnt/data/configs/deluge/.config/deluge --ui-interface 10.1.2.1";

  config.customLibs.networkNamespaces = {
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

  config.services.nginx.virtualHosts = {
    "deluge.local.ole.blue" = config.serviceSettings.nginx-local-ssl // {
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
}
