{
  lib,
  rlib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = if (config.capabilities.storage.lowAmount) then "--keep 1" else "--keep 5";
      dates = "daily";
    };
  };

  boot.tmp.cleanOnBoot = true;

  # nix.extraOptions = ''
  #   download-buffer-size = 500000000
  # '';

  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

  services.smartd.enable = lib.mkDefault true;
}
