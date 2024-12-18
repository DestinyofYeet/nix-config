{
  config,
  ...
}:
{
  services.prometheus = {
    enable = true;

    stateDir = "prometheus2";

    globalConfig = {
      scrape_interval = "10s";
    };

    scrapeConfigs = [
      {
        job_name = "zfs";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.zfs.port}" ];
          }
        ];
      }
      {
        job_name = "deluge";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.deluge.port}" ];
          }
        ];
      }
      {
        job_name = "qbittorrent";
        static_configs = [
          {
            targets = [
              "localhost:8090"
            ];
          }
        ];
      }
      {
        job_name = "systemd";
        static_configs = [
          {
            targets = [ "localhost:${toString config.services.prometheus.exporters.systemd.port}" ];
          }
        ];
      }
      {
        job_name = "hydra";
        static_configs = [
          {
            targets = [
              "localhost:9199"
              "localhost:9198"
            ];
          }
        ];
      }
    ];

    exporters.systemd = {
      enable = true;
    };
  };

}
