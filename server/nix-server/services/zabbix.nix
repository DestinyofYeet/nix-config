{ custom, ... }: {
  services.zabbixAgent = rec {
    enable = true;
    server = "bonk.nix-server.neb.ole.blue";
    # listen.ip = custom.nebula.yeet.hosts.nix-server.ip;
    openFirewall = true;
    settings = {
      Hostname = "nix-server";
      ServerActive = server;
    };
  };
}
