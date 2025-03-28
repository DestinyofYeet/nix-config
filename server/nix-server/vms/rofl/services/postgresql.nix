{ config, ... }: {
  microvm.shares = [{
    proto = "virtiofs";
    tag = "postgresql";
    source = "/mnt/data/data/wikijs/db";
    mountPoint = "/var/lib/postgresql";
  }];

  services.postgresql = {
    enable = true;

    ensureUsers = [

      {
        name = config.services.wiki-js.settings.db.user;
        ensureDBOwnership = true;
      }
    ];

    ensureDatabases = [ config.services.wiki-js.settings.db.db ];
  };
}
