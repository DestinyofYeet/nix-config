{ ... }: {
  home.stateVersion = "24.05";

  # needed for agenix service to start properly
  systemd.user.startServices = "sd-switch";

  imports = [
    ../../baseline/modules
    ./nu-scripts
    
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
    ./git.nix
    ./nix.nix
    ./helix.nix
    ./settings.nix
    ./xdg-open.nix
    ./mutt.nix
    ./yazi.nix
    ./fuck.nix
    ./zellij.nix
    ./zoxide.nix
    ./direnv.nix
    ./nushell.nix
    ./starship.nix
  ];
}
