{ config, pkgs, ... }:{
  services.jellyfin = {
    enable = true;
    dataDir = "${config.serviceSettings.paths.configs}/jellyfin";
    cacheDir = "/var/cache/jellyfin";
    inherit (config.serviceSettings) user group;
  };

  # intro-skipper patch
  nixpkgs.overlays = with pkgs; [
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

  services.nginx.virtualHosts."jellyfin.nix-server.infra.wg" = {
    locations."/" = {
      proxyPass = "http://localhost:8096";
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

  # was to removed due to a lack of maintanance
  # hardware.opengl = {
  #   extraPackages = with pkgs; [ linuxPackages.amdgpu-pro ];
  # };

  # boot.extraModulePackages = with config.boot.kernelPackages; [
  #   amdgpu-pro
  # ];

  # environment.systemPackages = with pkgs; [
  #   linuxPackages.amdgpu-pro
  # ];
}
