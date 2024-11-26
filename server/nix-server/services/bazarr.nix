{
  config,
  ...
}:{
  services.bazarr = {
    enable = true;

    inherit (config.serviceSettings) user group;
  };

  services.nginx = let
    default-config = {
      locations."/" = {
        proxyPass = "http://localhost:6767";
        extraConfig = ''
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        '';
      };
    };
  in {
    virtualHosts = {
      "bazarr.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-config;
    };
  };
}
