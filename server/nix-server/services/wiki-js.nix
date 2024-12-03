{
  config,
  ...
}:{
  services.wiki-js = {
    enable = true;

    settings = {
      bindIP = "127.0.0.1";
      port = 3002;

      db.host = "/run/postgresql";
      db.db = "wiki-js";
      db.user = "wiki-js";
    };
  };

  services.nginx.virtualHosts."wiki.local.ole.blue" = config.serviceSettings.nginx-local-ssl // {
    locations."/".proxyPass = "http://${config.services.wiki-js.settings.bindIP}:${toString config.services.wiki-js.settings.port}";
  };
}
