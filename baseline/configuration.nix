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
  ];

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep 10";
      dates = "daily";
    };
  };

  boot.tmp.cleanOnBoot = true;

  # nix.extraOptions = ''
  #   download-buffer-size = 500000000
  # '';

  nix = rlib.mkMerge [
    # match nix-channels (nix-shell) with nix flake input
    {
      nixPath = [

        "nixpkgs=/etc/channels/nixpkgs"
        "nixos-config=/etc/nixos/configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
    }
    {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        trusted-users = [
          "ole"
          "root"
        ];
        substituters = [
          "https://cache.ole.blue?priority=20"
          "https://install.determinate.systems"
        ];

        trusted-public-keys = [
          "cache.ole.blue:UB3+v071mF6riM4VUYqJxBRjtrCHWFxeGMzCMgxceUg="
          "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
        ];
      };
    }
    (rlib.mkIf {
      condition = config.capabilities.customNixInterpreter.enable;
      value = {

        settings = {
          eval-cores = 0;
          experimental-features = [ "wasm-builtin" ];
        };
      };
    })
  ];

  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

  services.smartd.enable = lib.mkDefault true;
}
