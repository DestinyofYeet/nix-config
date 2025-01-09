{
  flake,
  lib,
  ...
}:
let
  hosts = flake.nixosConfigurations.nix-server.config.services.nginx.virtualHosts;

  blacklistedHosts = [
    "sonarr.local.ole.blue"
    "prowlarr.local.ole.blue"
    "radarr.local.ole.blue"
    "qbittorrent.local.ole.blue"
    "deluge.local.ole.blue"
    "shoko.local.ole.blue"
    "firefly-importer.local.ole.blue"
    "bazarr.local.ole.blue"
  ];

  getPort = url: (builtins.elemAt (lib.splitString ":" (lib.last (lib.splitString "://" url))) 1);

  filteredHosts = lib.filterAttrs (name: value: !(lib.elem name blacklistedHosts)) (
    lib.filterAttrs (name: value: (lib.hasSuffix ".local.ole.blue" name)) hosts
  );

  nginxExtraConf = ''
    proxy_read_timeout 5m;
  '';

  # extremely slow
  transformedHosts = builtins.mapAttrs (name: value: {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      # proxyPass = "http://10.100.0.4:${getPort value.locations."/".proxyPass}";
      proxyPass = "https://local.ole.blue";
      extraConfig = nginxExtraConf + value.locations."/".extraConfig;
    };
    extraConfig = nginxExtraConf + value.extraConfig;
  }) filteredHosts;

in
{
  services.nginx.virtualHosts = transformedHosts;
}
