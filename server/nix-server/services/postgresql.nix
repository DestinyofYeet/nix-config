{
  config,
  lib,
  flake,
  pkgs,
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
      {
        name = flake.nixosConfigurations.teapot.config.services.gitea.database.user;
        ensureDBOwnership = true;
      }
    ];

    ensureDatabases = [
      "hydra"
      config.services.wiki-js.settings.db.db
      config.services.nextcloud.config.dbname
      flake.nixosConfigurations.teapot.config.services.gitea.database.name
    ];

    enableTCPIP = true;

    # https://github.com/DenisMedeiros/scram-sha-256-generator
    initialScript = pkgs.writeText "postgresql-init" ''
      alter user gitea with password 'SCRAM-SHA-256$4096:HOR5ZDmEZL0ywsp45Mnl4g==$6tBn2I9ZbZrKYrrYtf2PJIulS88zVSfuBBMFI12YRpM=:Hlc+vSFDC0V19mtC1cdIi++qGcvEb9vLu+D41fbqIXw=';
    '';
  };
}
