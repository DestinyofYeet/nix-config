{ config, pkgs, ... }:{
  services.jellyfin = {
    enable = true;
    package = pkgs.jellyfin;
    dataDir = "${config.serviceSettings.paths.configs}/jellyfin";
    cacheDir = "/var/cache/jellyfin";
    inherit (config.serviceSettings) user group;
  };

  # intro-skipper patch
  nixpkgs.overlays = [
    (
      final: prev:
        {
          jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
            installPhase = ''
              runHook preInstall

              # this is the important line
              sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

              mkdir -p $out/share
              cp -a dist $out/share/jellyfin-web

              runHook postInstall
            '';
          });
        }
    )
  ];

  services.nginx = 
  let
    default-config = {
      locations."/" = {
        proxyPass = "http://localhost:8096";
        extraConfig = ''
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
        '';
      };
    };
  in { 
    virtualHosts = {    
      "jellyfin.nix-server.infra.wg" = {} // default-config;
      "jellyfin.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-config;
    };
  }; 
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver # previously vaapiIntel
      vaapiVdpau # <--- I hope this is the one I need
      intel-compute-runtime # OpenCL filter support (hardware tonemapping and subtitle burn-in)
      vpl-gpu-rt # QSV on 11th gen or newer
      intel-media-sdk # QSV up to 11th gen
    ];
  };
}
