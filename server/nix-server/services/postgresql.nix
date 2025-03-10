{ config, lib, flake, pkgs, ... }: {
  age.secrets = {
    postgresql-init = {
      file = ../secrets/postgresql-init.age;
      owner = "postgres";
    };
  };

  services.postgresql = {
    enable = true;

    dataDir = "${
        lib.custom.settings.${config.networking.hostName}.paths.data
      }/postgresql";

    ensureUsers = let
      build-ensureUsers = names:
        [
          (map (x: {
            name = x;
            ensureDBOwnership = true;
          }) names)
        ];
      # build-ensureUsers [
      #   "hydra"
      #   # config.services.wiki-js.settings.db.user
      #   # config.services.nextcloud.config.dbuser
      #   # flake.nixosConfigurations.teapot.config.services.gitea.database.user
      # ];
    in [
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
        name = "lldap";
        ensureDBOwnership = true;
      }
      {
        name = config.services.immich.database.user;
        ensureDBOwnership = true;
      }
    ];

    authentication = ''
      host all all 10.100.0.1/32 md5
    '';

    ensureDatabases = [
      "hydra"
      config.services.wiki-js.settings.db.db
      config.services.nextcloud.config.dbname
      "lldap"
      config.services.immich.database.name
    ];

    enableTCPIP = true;

    # initialScript = config.age.secrets.postgresql-init.path;
  };

  systemd.services."postgresql-user-fixup" =
    lib.mkIf config.services.postgresql.enable {
      serviceConfig = {
        Type = "oneshot";
        User = "postgres";
      };

      wantedBy = [ "postgresql.service" ];
      after = [ "postgresql.service" ];

      script = ''
        cat ${config.age.secrets.postgresql-init.path} | ${pkgs.postgresql}/bin/psql
      '';
    };
}
