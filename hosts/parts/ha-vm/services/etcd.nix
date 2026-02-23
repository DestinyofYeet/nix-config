{ config, ... }:
let
  machines = import ../../../../custom/nebula/machines.nix;
in
{
  services.etcd = {
    enable = true;

    listenPeerUrls = [ "http://${(machines.${config.networking.hostName}).ip}:2380" ];

    listenClientUrls = [
      "http://${(machines.${config.networking.hostName}).ip}:2379"
      "http://localhost:2379"
    ];

    initialCluster = [
      "nix-server-ha-vm=http://${(machines."nix-server-ha-vm").ip}:2380"
      "teapot-ha-vm=http://${(machines."teapot-ha-vm").ip}:2380"
      "bonk-ha-vm=http://${(machines."bonk-ha-vm").ip}:2380"
    ];
  };
}
