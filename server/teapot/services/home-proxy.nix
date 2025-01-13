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
    "cloud.local.ole.blue"
  ];

  getPort = url: (builtins.elemAt (lib.splitString ":" (lib.last (lib.splitString "://" url))) 1);

  filteredHosts = lib.filterAttrs (name: value: !(lib.elem name blacklistedHosts)) (
    lib.filterAttrs (name: value: (lib.hasSuffix ".local.ole.blue" name)) hosts
  );

  # extremely slow
  transformedHosts = builtins.mapAttrs (name: value: {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      # proxyPass = "http://10.100.0.4:${getPort value.locations."/".proxyPass}";
      proxyPass = "https://local.ole.blue";
      extraConfig = value.locations."/".extraConfig;
    };
    extraConfig = value.extraConfig;
  }) filteredHosts;

in
{
  services.nginx.virtualHosts = transformedHosts // {
    "cloud.local.ole.blue" = {
      locations."/".proxyPass = "https://local.ole.blue";
      forceSSL = true;
      enableACME = true;

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Content-Type-Options nosniff;
      '';
    };
  };
}
