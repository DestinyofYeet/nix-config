{
  config,
  lib,
  flake,
  pkgs,
  ...
}:
{
  age.secrets = {
    postgresql-init.file = ../secrets/postgresql-init.age;
  };

  services.postgresql = {
    enable = true;

    dataDir = "${lib.custom.settings.${config.networking.hostName}.paths.data}/postgresql";

    ensureUsers = let
      build-ensureUsers = names: [
        (map (x: {name = x; ensureDBOwnership = true;}) names)
      ];
    in
    # build-ensureUsers [
    #   "hydra"
    #   # config.services.wiki-js.settings.db.user
    #   # config.services.nextcloud.config.dbuser
    #   # flake.nixosConfigurations.teapot.config.services.gitea.database.user
    # ];
    [
      {
        name = "hydra";
        ensureDBOwnership = true;
      }
      {
        name = "${config.services.wiki-js.settings.db.user}";
        ensureDBOwnership = true;
      }
      {
        name = config.services.nextcloud.config.dbuser;
        ensureDBOwnership = true;
      }
      {
        name = flake.nixosConfigurations.teapot.config.services.gitea.database.user;
        ensureDBOwnership = true;
      }
      {
        name = flake.nixosConfigurations.teapot.config.services.roundcube.database.username;
        ensureDBOwnership = true;
      }
    ];

    authentication = ''
      host all all 10.100.0.1/32 password
    '';
  
    ensureDatabases = [
      "hydra"
      config.services.wiki-js.settings.db.db
      config.services.nextcloud.config.dbname
      flake.nixosConfigurations.teapot.config.services.gitea.database.name
      flake.nixosConfigurations.teapot.config.services.roundcube.database.dbname
    ];

    enableTCPIP = true;

    initialScript = config.age.secrets.postgresql-init.path;
  };
}
