{
  config,
  pkgs,
  lib,
  ...
}:
let
  config-json = pkgs.writeText "config.json" (
    builtins.toJSON {
      "menuLinks" = [
        {
          name = "SSO Linking";
          url = "https://jellyfin.local.ole.blue/SSOViews/linking";
        }
      ];
    }
  );
in
{
  services.jellyfin = {
    enable = true;
    package = pkgs.jellyfin;
    dataDir = "${lib.custom.settings.${config.networking.hostName}.paths.configs}/jellyfin";
    cacheDir = "/var/cache/jellyfin";
    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };

  # intro-skipper patch
  nixpkgs.overlays = [
    (final: prev: {
      jellyfin-web = prev.jellyfin-web.overrideAttrs (
        finalAttrs: previousAttrs: {
          installPhase = ''
            runHook preInstall

            # this is the important line
            sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

            mkdir -p $out/share
            cp -a dist $out/share/jellyfin-web

            # cp ${config-json} $out/share/jellyfin-web/config.json

            runHook postInstall
          '';
        }
      );
    })
  ];

  systemd.services.jellyfin = rec {
    requires = [ "docker-shokoserver.service" ];
    before = requires;
  };

  services.nginx =
    let
      default-config = {
        locations."/" = {
          proxyPass = "http://localhost:8096";
          extraConfig = ''
            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
            proxy_set_header Host $host;
            proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $http_host;
            proxy_set_header X-Forwarded-URI $request_uri;
            proxy_set_header X-Forwarded-Ssl on;
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Real-IP $remote_addr;
          '';
        };
      };
    in
    {
      virtualHosts = {
        "jellyfin.local.ole.blue" =
          lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
      };
    };
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver # <--- I hope this is the one I need
    ];
  };
}
