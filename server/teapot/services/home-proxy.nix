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

  filteredHosts = lib.filterAttrs (name: value: !(lib.elem name blacklistedHosts)) (
    lib.filterAttrs (name: value: (lib.hasSuffix ".local.ole.blue" name)) hosts
  );

  transformedHosts = builtins.mapAttrs (name: value: {
    forceSSL = true;
    enableACME = true;
    locations."/".proxyPass = "https://10.100.0.4";
    extraConfig = ''
      proxy_set_header X-Real-IP $remote_addr;
    	proxy_set_header Host $host;
    	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    	proxy_set_header X-Forwarded-Proto $scheme;
    '';
  }) filteredHosts;

in
{
  services.nginx.virtualHosts = transformedHosts;
}
