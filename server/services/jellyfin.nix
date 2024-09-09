{ config, pkgs, ... }:{
  services.jellyfin = {
    enable = true;
    dataDir = "/configs/jellyfin";
    inherit (config.serviceSettings) user group;
  };

  ## patch intro-skipper. Doesn't work
  # nixpkgs.overlays = with pkgs; [
  #   (
  #     final: prev:
  #       {
  #         jellyfin-web = prev.jellyfin-web.overrideAttrs (finalAttrs: previousAttrs: {
  #           installPhase = ''
  #             runHook preInstall

  #             # this is the important line
  #             sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

  #             mkdir -p $out/share
  #             cp -a dist $out/share/jellyfin-web

  #             runHook postInstall
  #           '';
  #         });
  #       }
  #   )
  # ];

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
