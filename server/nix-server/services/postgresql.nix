{ config, lib, flake, pkgs, ... }: {
  age.secrets = {
    postgresql-init = {
      file = ../secrets/postgresql-init.age;
      owner = "postgres";
    };
  };

  environment.systemPackages = [
    (let
      # XXX specify the postgresql package you'd like to upgrade to.
      # Do not forget to list the extensions you need.
      newPostgres = pkgs.postgresql_16.withPackages (pp:
        with pp; [

          vectorchord
          pgvector
          pgvecto-rs
        ]);
      cfg = config.services.postgresql;
    in pkgs.writeScriptBin "upgrade-pg-cluster" ''
      set -eux
      # XXX it's perhaps advisable to stop all services that depend on postgresql
      systemctl stop postgresql

      export NEWDATA="/mnt/data/data/postgresql/${newPostgres.psqlSchema}"
      export NEWBIN="${newPostgres}/bin"

      export OLDDATA="${cfg.dataDir}"
      export OLDBIN="${cfg.finalPackage}/bin"

      install -d -m 0700 -o postgres -g postgres "$NEWDATA"
      cd "$NEWDATA"
      sudo -u postgres "$NEWBIN/initdb" -D "$NEWDATA" ${
        lib.escapeShellArgs cfg.initdbArgs
      }

      sudo -u postgres "$NEWBIN/pg_upgrade" \
        --old-datadir "$OLDDATA" --new-datadir "$NEWDATA" \
        --old-bindir "$OLDBIN" --new-bindir "$NEWBIN" \
        --old-options "-c shared_preload_libraries='vchord.so,vector.so,vectors.so'" \
        --new-options "-c shared_preload_libraries='vchord.so,vector.so,vectors.so'" \
        "$@"
    '')
  ];

  systemd.services.postgresql.postStart = let
    replicationUser = "authentik_replicator";
    subscriptionName = "sub_authentik";
    createRoleCommand = ''
      CREATE ROLE ${replicationUser} LOGIN REPLICATION;
    '';
    grantPermissionsCommand = ''
      grant all privileges on database authentik to ${replicationUser};
      grant all on schema public to ${replicationUser};
      grant select on all tables in schema public to ${replicationUser};
      grant usage on schema public to ${replicationUser};

      grant all privileges on database authentik to authentik;
      grant all on schema public to authentik;
      grant select on all tables in schema public to authentik;
      grant usage on schema public to authentik;
    '';
    createSubscriptionCommand = ''
      create subscription ${subscriptionName} connection 'host=172.27.255.2 port=5432 user=authentik_replicator dbname=authentik' publication pub_authentik with (origin = 'none');
    '';
    createPublicationCommand = ''
      create publication pub_authentik for all tables;
    '';
  in lib.mkAfter ''
    if psql -t -c '\du' | cut -d \| -f 1 | grep -qw ${replicationUser}; then
      echo User ${replicationUser} exists. Skipping
    else
      psql -d authentik -tAc "${createRoleCommand}"
      psql -d authentik -tAc "${createPublicationCommand}"
      echo Please run "${createSubscriptionCommand}" in the authentik database.
    fi
    psql -d authentik -tAc "${grantPermissionsCommand}"
  '';

  services.postgresql = {
    enable = true;
    settings = {
      wal_level = "logical";
      max_replication_slots = 1024;

    };
    package = pkgs.postgresql_16;

    dataDir = "${
        lib.custom.settings.${config.networking.hostName}.paths.data
      }/postgresql/${toString config.services.postgresql.package.psqlSchema}";

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
      host authentik authentik_replicator 172.27.255.1/32 trust
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
