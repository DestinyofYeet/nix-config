{ ... }: {
  programs.atuin = {
    enable = true;
    flags = [ "--disable-up-arrow" ];
    enableNushellIntegration = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://atuin.ole.blue";
    };
  };
}
