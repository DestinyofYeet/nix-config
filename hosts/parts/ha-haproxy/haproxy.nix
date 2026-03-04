{
  config,
  ...
}:
let
  vpnMachines = import ../../../custom/nebula/machines.nix;

  localIp = vpnMachines.${config.networking.hostName}.ip;
in
{
  services.haproxy = {
    enable = true;

    config = ''
      global
        maxconn 200

      defaults
        log global
        mode tcp
        retries 2
        timeout client 30m
        timeout connect 4s
        timeout server 30m

      frontend postgres_write
        bind ${localIp}:5432
        default_backend postgres_primary

      backend postgres_primary
        mode tcp
        option httpchk GET /primary
        http-check expect status 200

        server teapot-ha-vm ${vpnMachines."teapot-ha-vm".ip}:5432 check port 8008
        server bonk-ha-vm ${vpnMachines."bonk-ha-vm".ip}:5432 check port 8008
        server nix-server-ha-vm ${vpnMachines."nix-server-ha-vm".ip}:5432 check port 8008

      frontend postgres_read
        bind ${localIp}:5433
        default_backend postgres_replicas

      backend postgres_replicas
        mode tcp
        balance roundrobin
        option httpchk GET /replica

        server teapot-ha-vm ${vpnMachines."teapot-ha-vm".ip}:5432 check port 8008
        server bonk-ha-vm ${vpnMachines."bonk-ha-vm".ip}:5432 check port 8008
        server nix-server-ha-vm ${vpnMachines."nix-server-ha-vm".ip}:5432 check port 8008
    '';
  };
}
