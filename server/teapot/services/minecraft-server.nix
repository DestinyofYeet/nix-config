{ pkgs, lib, config, ... }: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ "minecraft-server" ];

  services.minecraft-servers = {
    enable = true;
    eula = true;
    dataDir = "/var/lib/minecraft-servers";
    servers.hannes-geburtstag = {
      enable = true;
      package = pkgs.vanillaServers.vanilla;
      managementSystem = {
        # tmux.enable = false;
        # systemd-socket.enable = true;
      };
      serverProperties = {
        difficulty = 1;
        motd = "Hannes hat geburtstag";
        server-port = 25565;
        online-mode = false;
      };
    };
  };

  networking.firewall = let
    ports = with config.services.minecraft-servers.servers;
      [ hannes-geburtstag.serverProperties.server-port ];
  in {

    allowedUDPPorts = ports;
    allowedTCPPorts = ports;
  };

  programs.tmux.enable = true;
}
