{ config, lib, pkgs, ... }: {
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

      export NEWDATA="/var/lib/postgresql/${newPostgres.psqlSchema}"
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
      grant all privileges on database authentik to ${replicationUser};
      grant all on schema public to ${replicationUser};
      grant select on all tables in schema public to ${replicationUser};
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
  '';

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    settings = {
      wal_level = "logical";
      max_replication_slots = 1024;
    };

    extensions = ps: with ps; [ vectorchord pgvecto-rs pgvector ];

    enableTCPIP = true;

    authentication = ''
      host authentik authentik_replicator 172.27.255.2/32 trust
    '';

    ensureUsers = [{
      name = config.services.forgejo.database.user;
      ensureDBOwnership = true;
    }];

    ensureDatabases = [ config.services.forgejo.database.name ];
  };
}
