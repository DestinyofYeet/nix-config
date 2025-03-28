{ config, lib, ... }: {
  services.wiki-js = {
    enable = false;

    settings = {
      bindIP = "127.0.0.1";
      port = 3002;

      db.host = "/run/postgresql";
      db.db = "wiki-js";
      db.user = "wiki-js";
    };
  };
}
