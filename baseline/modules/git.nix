{ rlib, capabilities, ... }: {
  programs = rlib.mkMerge [
    {
      git.enable = true;
    }

    (rlib.mkIf (!capabilities.storage.lowAmount) {
      lazygit.enable = true;
    })
  ];
}
