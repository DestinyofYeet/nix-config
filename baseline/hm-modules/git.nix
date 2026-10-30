{ rlib, osConfig, ... }: {
  programs = rlib.mkMerge [
    {
      git.enable = true;
    }

    (rlib.mkIf (!osConfig.capabilities.storage.lowAmount) {
      lazygit.enable = true;
    })
  ];
}
