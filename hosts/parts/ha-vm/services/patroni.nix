{ config, lib, ... }:
let
  machines = import ../../../../custom/nebula/machines.nix;

  otherNodes =
    machines:
    lib.mapAttrsToList (_v: v: v.ip) lib.filterAttrs (
      name: value: value.ip != (machines.${config.network.hostName}).ip
    );
in
{
  services.patroni = {
    nodeIp = "${(machines.${config.network.hostName}).ip}";
    otherNodesIps = (
      otherNodes [
        machines."nix-server-ha-vm"
        machines."bonk-ha-vm"
        machines."teapot-ha-vm"
      ]
    );

    scope = "haCluster";
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
    };

  };
}
