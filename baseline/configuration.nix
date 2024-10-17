{ ... }: {

  # automatically collect garbage
  nix.gc = {
    automatic = true;
    persistent = true;

    options = "--delete-older-than +10";
    dates = "05:00:00"; 
  };

  # optimise nix-store with deduplication
  nix.settings.auto-optimise-store = true;

  nix.settings.max-jobs = "auto";
}

