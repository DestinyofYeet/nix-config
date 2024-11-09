{
  config,
  ...
}:{
  services.prometheus = {
    enable = true;
    
    globalConfig = {
      scrape_interval = "10s";
    };

    scrapeConfigs = [
      {
        job_name = "zfs";
        static_configs = [{
          targets = [ "localhost:${toString config.services.prometheus.exporters.zfs.port}"];
        }];
      }
      # {
      #   job_name = "qbittorrent";
      #   static_configs = [{
      #     targets = [ "localhost:${config.virtualisation.oci-containers.containers."prometheus-qbittorrent-exporter".environment.QBITTORRENT_PORT}"];
      #   }];
      # }
      {
        job_name = "deluge";
        static_configs = [{
          targets = [ "localhost:${toString config.services.prometheus.exporters.deluge.port}"];
        }];
      }
    ];
  };
}
