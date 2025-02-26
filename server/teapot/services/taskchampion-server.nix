{
  config,
  pkgs,
  custom,
  ...
}:
{
  services.taskchampion-sync-server = {
    enable = true;
    # currently failing sqllite test
    # package = pkgs.callPackage ./pkgs/taskchampion.nix {};
  };

  services.nginx.virtualHosts."task-sync.ole.blue" = {
    listenAddresses = [ "172.27.255.1" ];
    locations."/".proxyPass =
      "http://127.0.0.1:${toString config.services.taskchampion-sync-server.port}";
  };
}
