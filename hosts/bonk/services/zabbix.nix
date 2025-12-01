{ pkgs, ... }:
let zabbix-pkg = pkgs.zabbix72;
in {
  services.zabbixServer = {
    enable = true;
    package = zabbix-pkg.server;
    database.createLocally = true;
    openFirewall = true;
    listen.port = 10051;
  };

  services.zabbixWeb = {
    enable = true;
    package = zabbix-pkg.web;
    frontend = "nginx";
    hostname = "stats.ole.blue";
    nginx = {
      virtualHost = {
        enableACME = true;
        forceSSL = true;
      };
    };
  };

  services.zabbixAgent = {
    enable = true;
    package = zabbix-pkg.agent;
    server = "127.0.0.1";
    settings = { Hostname = "Zabbix server"; };
  };
}
