{ ... }: {
  home.stateVersion = "24.05";

  imports = [
    ./kde.nix
    ./vim.nix
  ];
}
