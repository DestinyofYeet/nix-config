{ config, ... }: {
  services.strichliste-rs = {
    enable = true;
    address = "127.0.0.1";
    port = 8936;
  };

  services.nginx.virtualHosts."strichliste-demo.ole.blue" =
    let cfg = config.services.strichliste-rs;
    in {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://${cfg.address}:${toString cfg.port}";
      };
    };
}
