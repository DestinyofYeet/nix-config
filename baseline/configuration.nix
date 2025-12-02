{ lib, config, pkgs, inputs, capabilities, ... }: {
  imports = [ ./packages.nix ]
    ++ (lib.optionals (capabilities.nebulaVpn.enable) [ ./nebula.nix ])
    ++ (lib.optionals (capabilities.customNixInterpreter.enable) [ ./lix.nix ]);

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

  # match nix-channels (nix-shell) with nix flake input
  nix.nixPath = [
    "nixpkgs=/etc/channels/nixpkgs"
    "nixos-config=/etc/nixos/configuration.nix"
    "/nix/var/nix/profiles/per-user/root/channels"
  ];
  environment.etc."channels/nixpkgs".source = inputs.nixpkgs.outPath;

  services.smartd.enable = lib.mkDefault true;
}
