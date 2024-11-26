{
  config,
  ...
}:{
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 45128;

        domain = "dashboard.local.ole.blue";
      };

      analytics.reporting_enabled = false;

      # datasources.settings.datasources = [
      #   {
      #     name = "Prometheus";
      #     type = "prometheus";
      #     url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
      #   }
      # ];
    };
  };

  services.nginx.virtualHosts."dashboard.local.ole.blue" = config.serviceSettings.nginx-local-ssl // {
    locations."/" = {
      proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
    };
  };
}
