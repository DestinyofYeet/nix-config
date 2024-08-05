{ ... }: {
  home.stateVersion = "24.05";

  imports = [
    ../../baseline/modules
    ./kde.nix
    ./bash.nix
    ./stylix.nix
    ./firefox.nix
    ./kitty.nix
    ./zsh.nix
    ./nextcloud.nix
    ./btop.nix
  ];
}
