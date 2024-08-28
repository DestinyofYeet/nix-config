{ ... }: {

  # automatically collect garbage
  nix.gc = {
    automatic = true;
    persistent = true;
  };

  # optimise nix-store with deduplication
  nix.settings.auto-optimise-store = true;
}

