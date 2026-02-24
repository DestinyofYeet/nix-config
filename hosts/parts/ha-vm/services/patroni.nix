{
  secretStore,
  config,
  lib,
  pkgs,
  ...
}:
let
  machines = import ../../../../custom/nebula/machines.nix;

  otherNodes =
    machines:
    lib.mapAttrsToList (_v: v: v.ip) lib.filterAttrs (
      name: value: value.ip != (machines.${config.networking.hostName}).ip
    );

  commonSecrets = secretStore.getServerSecrets "common";
in
{
  age.secrets = {
    patroni-superuser-pw.file = commonSecrets + "/ha-vm-patroni-superuser-pw.age";
    patroni-replicationuser-pw.file = commonSecrets + "/ha-vm-patroni-replication-pw.age";
  };

  # currently broken https://github.com/nixos/nixpkgs/issues/480064
  services.patroni = {
    enable = true;

    name = config.networking.hostName;

    postgresqlPackage = pkgs.postgresql_18;

    nodeIp = "${(machines.${config.networking.hostName}).ip}";
    otherNodesIps = (
      otherNodes [
        machines."nix-server-ha-vm"
        machines."bonk-ha-vm"
        machines."teapot-ha-vm"
      ]
    );

    scope = "haCluster";

    environmentFiles = {
      PATRONI_REPLICATION_PASSWORD = config.age.secrets.patroni-replicationuser-pw.path;
      PATRONI_SUPERUSER_PASSWORD = config.age.secrets.patroni-superuser-pw.path;
    };

    settings = {
      etcd = {
        hosts = [
          "nix-server-ha-vm:2379"
          "teapot-ha-vm:2379"
          "bonk-ha-vm:2379"
        ];
      };

      bootstrap = {
        dcs = {
          ttl = 30;
          loop_wait = 10;
          retry_timeout = 10;
          maximum_lag_failover = 1048576;

          postgresql = {
            use_pg_rewind = true;
            use_slots = true;
            parameters = {
              wal_level = "replica";
              hot_standby = "on";
              max_wal_senders = 10;
              max_replication_slots = 10;
              wal_keep_size = "256MB";
            };
          };
        };
      };

      postgresql = {
        authentication = {
          superuser.username = "superuser";
          replication.username = "replicationuser";
        };
        parameters = {
          unix_socket_directories = "/var/run/postgresql";
          shared_buffers = "1GB";
          effective_cache_size = "3GB";
          maintenance_work_mem = "256MB";
          max_connections = 200;
          synchronous_commit = "on";
        };
      };
    };

  };
}
