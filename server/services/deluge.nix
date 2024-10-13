{
  config,
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
  };

  config.systemd.services.deluged.serviceConfig.NetworkNameSpacePath = "/var/run/netns/deluge";

  config.customLibs.networkNamespaces = {
    enable = true;
    spaces = {
      deluge = {
        enable = true;
        upholdsServices = [ "deluged.service" ];
        networkIpIn = "10.1.1.3";
        networkIpOut = "10.1.1.4";
        wireguardConfigPath = config.age.secrets.airvpn-deluge.path;
      }; 

      test = {
        enable = true;
        networkIpIn = "10.1.1.5";
        networkIpOut = "10.1.1.6";
        wireguardConfigPath = config.age.secrets.airvpn-deluge.path;
      };
    };
  };
}
