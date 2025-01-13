{
  config,
  lib,
  ...
}:
{

  # containers.postgresql = {
  #   autoStart = false;

  #   bindMounts = {
  #     "/var/lib/postgresql-custom" = {
  #       hostPath = "${config.serviceSettings.paths.data}/postgresql";
  #       isReadOnly = false;
  #     };
  #   };

  #   config = { config, pkgs, lib, ...} : {

  #     services.postgresql = {
  #       enable = true;

  #       dataDir = "/var/lib/postgresql-custom";

  #       settings.port = 54321;
  #     };

  #     system.stateVersion = "24.05";
  #   };
  # };

  services.postgresql = {
    enable = true;

    dataDir = "${lib.custom.settings.${config.networking.hostName}.paths.data}/postgresql";

    ensureUsers = [
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
    ];

    ensureDatabases = [
      "hydra"
      config.services.wiki-js.settings.db.db
      config.services.nextcloud.config.dbname
    ];
  };
}
