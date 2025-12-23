{ pkgs, config, lib, ... }:
lib.mkIf (config.capabilities.wavesurfer-ld.enable) {

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # wavesurfer
      libxft
      fontconfig
      libx11
      libxscrnsaver
      libxext
      alsa-lib
    ];
  };
}
