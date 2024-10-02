{
  config,
  ...
}:

let
  root-domain = "nix-server.infra.wg";
  ip = "192.168.0.250";
  build-subdomains = sub-domains:
    (map (sub-domain:  "\"${sub-domain}.${root-domain}. IN A ${ip}\"") sub-domains);
in {
  services.unbound = {
    enable = true;
    resolveLocalQueries = true;
    settings = {
      server = {
        interface = [ "0.0.0.0" "::0" ];
        port = 53;
        access-control =
          [ "0.0.0.0/0 allow" "::0/0 allow" ];

        harden-glue = true;
        harden-dnssec-stripped = true;
        use-caps-for-id = false;
        prefetch = true;
        edns-buffer-size = 1232;

        # Custom settings
        hide-identity = true;
        hide-version = true;

        # no quotes
        local-zone = [
          "${root-domain}. static"
        ];

        # needs quotes
        local-data = [
          "\"${root-domain}. IN A ${ip}\""
        ] ++ build-subdomains [
          "jellyfin"
          "firefly"
          "cache"
          "hydra"
          "qbittorrent"
          "sonarr"
          "prowlarr"
          "navidrome"
          "syncthing"
        ];
      };
      forward-zone = [
        {
          name = ".";
          forward-addr =
            [ 
              "9.9.9.9@853" 
              "8.8.8.8@853" 
              "1.1.1.1@853" 
            ];
          forward-tls-upstream = true;
        }
      ];
    };
  };

}
