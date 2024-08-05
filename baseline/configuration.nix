{ ... }: {

  # automatically collect garbage
  nix.gc.automatic = true;

  # optimise nix-store with deduplication
  nix.settings.auto-optimise-store = true;
}

