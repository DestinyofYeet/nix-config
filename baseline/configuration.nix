{ lib, config, pkgs, inputs, ... }: {
  imports = [ ./packages.nix ./nebula.nix ];

  # automatically collect garbage
  # config = {
  #   nix.gc = {
  #     automatic = true;
  #     persistent = true;
  #     options = "10";
  #     dates = "05:00:00";
  #   };

  #   # optimise nix-store with deduplication
  #   # nix.settings.auto-optimise-store = true;

  #   nix.optimise.automatic = true;

  #   nix.settings.max-jobs = "auto";
  # };

  # config.systemd.services.nix-gc = lib.mkIf config.nix.enable {
  #   script = lib.mkForce ''
  #     ${pkgs.nushell}/bin/nu ${../non-server/modules/nu-scripts/custom-nix-gc.nu} ${config.nix.gc.options}
  #   '';
  # };

  nix.package = pkgs.lix;

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

  services.smartd.enable = true;
}
