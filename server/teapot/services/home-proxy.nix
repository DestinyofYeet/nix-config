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

  # getPort = url: (builtins.elemAt (lib.splitString ":" (lib.last (lib.splitString "://" url))) 1);

  filteredHosts = lib.filterAttrs (name: value: !(lib.elem name blacklistedHosts)) (
    lib.filterAttrs (name: value: (lib.hasSuffix ".local.ole.blue" name)) hosts
  );

  # extremely slow
  transformedHosts = builtins.mapAttrs (name: value: {
    # forceSSL = true;
    # enableACME = true;
    locations."/" = {
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

      extraConfig =
        flake.nixosConfigurations.nix-server.config.services.nginx.virtualHosts."cloud.local.ole.blue".extraConfig;

      # extraConfig = ''
      #   proxy_set_header Host $host;
      #   proxy_set_header X-Real-IP $remote_addr;
      #   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      #   proxy_set_header X-Forwarded-Proto $scheme;

      #   add_header X-Content-Type-Options nosniff;
      #   add_header Strict-Transport-Security "max-age=15552000; includeSubDomains";
      #   add_header X-XSS-Protection "1; mode=block";
      #   add_header X-Robots-Tag "noindex, nofollow";
      #   add_header X-Frame-Options "SAMEORIGIN";
      #   add_header Referrer-Policy "no-referrer";

      #   client_max_body_size ${flake.nixosConfigurations.nix-server.config.services.nextcloud.maxUploadSize};
      # '';
    };
  };
}
