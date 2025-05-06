{ custom, pkgs, ... }:
let
  zabbix-pkg = pkgs.zabbix72;
  nebula-hosts = custom.nebula.yeet.hosts;
in {
  services.zabbixAgent = rec {
    enable = true;
    package = zabbix-pkg.agent;
    server = nebula-hosts.bonk.ip;
    # listen.ip = custom.nebula.yeet.hosts.nix-server.ip;
    openFirewall = true;
    settings = {
      Hostname = "nix-server";
      ServerActive = server;
    };
  };
}
