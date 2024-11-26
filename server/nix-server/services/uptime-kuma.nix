{ config, ... }:{
  services.uptime-kuma = {
    enable = true;
    settings = {
      HOST = "0.0.0.0";
    };
  };

  services.nginx = let 

    default-conf = {
      locations."/" = {
        proxyPass = "http://localhost:3001";
      };
    };

  in {
    virtualHosts = {
      "uptime.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-conf;
    };
  };
}
