{
  lib,
  rlib,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./packages.nix
    ./nebula.nix
    ./caches.nix
  ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 5";
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
