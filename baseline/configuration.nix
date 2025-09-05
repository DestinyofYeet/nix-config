{ lib, config, pkgs, inputs, ... }: {
  imports = [ ./packages.nix ./nebula.nix ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 10";
      dates = "daily";
    };
  };

  boot.tmp.cleanOnBoot = true;

  nix.settings = {
    eval-cores = 0;
    extra-experimental-features = "parallel-eval";

    substituters = [ "https://install.determinate.systems" ];
    trusted-public-keys =
      [ "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM=" ];
  };

  # nix.extraOptions = ''
  #   download-buffer-size = 500000000
  # '';

  # match nix-channels (nix-shell) with nix flake input
  nix.nixPath = [
    "nixpkgs=/etc/channels/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

  services.smartd.enable = lib.mkDefault true;
}
