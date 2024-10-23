{ lib, config, ... }: {

  # automatically collect garbage
  config = {
    nix.gc = {
      automatic = true;
      persistent = true;

      options = "--delete-generations +10";
      dates = "05:00:00"; 
    };

    # optimise nix-store with deduplication
    nix.settings.auto-optimise-store = true;

    nix.settings.max-jobs = "auto";
  };

  config.systemd.services.nix-gc = lib.mkIf config.nix.enable {
    script = lib.mkForce ''
      exec ${config.nix.package.out}/bin/nix-env ${config.nix.gc.options}
      exec ${config.nix.package.out}/bin/nix-collect-garbage'';
  };
}

