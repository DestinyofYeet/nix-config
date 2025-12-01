{ ... }: {
  services.elasticsearch = {
    enable = true;
    listenAddress = "127.0.0.1";
    dataDir = "/mnt/data/data/elasticsearch";
  };
}
