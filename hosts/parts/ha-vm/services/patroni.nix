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

  cidr = "172.27.255.0/24";

  commonSecrets = secretStore.getServerSecrets "common";
in
{
  age.secrets =
    let
      ownership = {
        owner = "patroni";
        group = "patroni";
      };
    in
    {
      patroni-superuser-pw = {
        file = commonSecrets + "/ha-vm-patroni-superuser-pw.age";
      }
      // ownership;

      patroni-replicationuser-pw = {
        file = commonSecrets + "/ha-vm-patroni-replication-pw.age";
      }
      // ownership;
    };

  services.patroni = {
    enable = true;

    softwareWatchdog = true;

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
      etcd3 = {
        hosts = [
          "${machines."nix-server-ha-vm".ip}:2379"
          "${machines."teapot-ha-vm".ip}:2379"
          "${machines."bonk-ha-vm".ip}:2379"
        ];
      };

      bootstrap = {
        dcs = {
          ttl = 30;
          loop_wait = 10;
          retry_timeout = 10;
          maximum_lag_on_failover = 1048576;
          check_timeline = true;
        };
      };

      postgresql = {
        use_pg_rewind = true;

        authentication = {
          superuser.username = "postgres";
          replication.username = "replicationuser";
        };

        parameters = {
          shared_buffers = "1GB";
          effective_cache_size = "3GB";
          maintenance_work_mem = "256MB";
          synchronous_commit = "on";
          unix_socket_directories = "/tmp";
          max_connections = 200;
          max_wal_senders = 10;
          max_replication_slots = 10;

          wal_level = "replica";
          host_standby = "on";
          wal_log_hints = "on";
        };

        pg_hba = [
          "host replication replicationuser ${cidr} scram-sha-256"
          "host all postgres ${cidr} scram-sha-256"
          "host all all ${cidr} scram-sha-256"
          "host all all 127.0.0.1/32 scram-sha-256"
        ];
      };
    };

  };
}
