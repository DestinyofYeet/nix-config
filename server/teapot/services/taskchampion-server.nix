{
  config,
  pkgs,
  ...
}:{
  services.taskchampion-sync-server = {
    enable = true;
    # currently failing sqllite test
    # package = pkgs.callPackage ./pkgs/taskchampion.nix {};
  };

  services.nginx.virtualHosts."task-sync.ole.blue" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://127.0.0.1:${toString config.services.taskchampion-sync-server.port}";
  };
}
