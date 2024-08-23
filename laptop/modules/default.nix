{ ... }: {
  home.stateVersion = "24.05";

  # needed for agenix service to start properly
  systemd.user.startServices = "sd-switch";

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
    ./ssh.nix
    ./agenix.nix
    ./nvim.nix
  ];
}
