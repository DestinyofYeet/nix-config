{
  config,
  secretStore,
  ...
}:
let
  commonSecrets = secretStore.getHostSecrets "common";
in
{
  age.secrets = {
    stalwart-prometheus = {
      file = commonSecrets.getSecret "stalwart-prometheus-pw";
      owner = config.systemd.services.prometheus.serviceConfig.User;
    };
  };

  services.prometheus = {
    enable = true;

    stateDir = "prometheus2";

    globalConfig = {
      scrape_interval = "10s";
    };

    scrapeConfigs = [
      {
        job_name = "stalwart";
        scrape_interval = "1m";
        scheme = "https";
        metrics_path = "/metrics/prometheus";
        basic_auth = {
          username = "prometheus";
          password_file = config.age.secrets.stalwart-prometheus.path;
        };
        static_configs = [
          {
            targets = [ "mail.ole.blue" ];
          }
        ];
      }
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
      {
        job_name = "nginx-teapot";
        static_configs = [
          {
            targets = [
              "10.100.0.1:9113"
            ];
          }
        ];
      }
      {
        job_name = "unbound";
        static_configs = [
          {
            targets = [
              "localhost:9167"
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
