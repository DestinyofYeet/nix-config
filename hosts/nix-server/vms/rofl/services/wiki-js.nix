{ config, ... }: {
  services.wiki-js = {
    enable = true;
    settings = {
      log_level = "silly";
      bindIP = "0.0.0.0";
      port = 3002;
      db = rec {
        host = "/run/postgresql";
        db = "wiki-js";
        user = db;
      };
    };
  };
}
