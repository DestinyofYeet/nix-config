{
  config,
  pkgs,
  ...
}:

let
  root-domain = "nix-server.infra.wg";
  ip = "192.168.0.250";
  build-subdomains = build-domain: build-ip: sub-domains:
    (map (sub-domain:  (wrap-string "${sub-domain}.${build-domain}. IN A ${build-ip}")) sub-domains);

  wrap-string = string:
    "\"${string}\"";

  zone-file = pkgs.writeText "local.ole.blue.zone" ''
    $TTL 86400

    @  IN  SOA ns.local.ole.blue ole@uwuwhatsthis.de. (
      2024100501   ; YYYYMMDDNN Serial
      3600         ; Refresh
      1800         ; Retry
      1209600      ; Expire
      86400        ; Minimum TTL
    ) IN NS ns.local.ole.blue.

    ns.local.ole.blue.   IN A 192.168.0.250
    local.ole.blue.      IN A 192.168.0.250
    *.local.ole.blue.    IN A 192.168.0.250
  '';
in {
  services.unbound = {
    enable = true;
    checkconf = true;
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
        ] ++ build-subdomains "nix-server.infra.wg" "192.168.0.250" [
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

      # I want the unbound server to have a local storage of the zone data incase the internet goes out
      auth-zone = [
        {
          name = wrap-string "local.ole.blue";
          zonefile = wrap-string "${zone-file}";
        }
      ];

      forward-zone = [
        {
          name = ".";
          forward-addr =
            [ 
              # 853 for tls
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
