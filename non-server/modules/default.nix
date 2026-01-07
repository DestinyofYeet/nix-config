{ osConfig, ... }: {
  home.stateVersion = "24.05";

  # needed for agenix service to start properly
  systemd.user.startServices = "sd-switch";

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = osConfig.nixpkgs.overlays;

  imports = [
    ../../baseline/modules
    ./nu-scripts

    ./bash.nix
    ./stylix.nix
    ./firefox.nix
    ./kitty.nix
    ./zsh.nix
    ./nextcloud.nix
    ./btop.nix
    ./ssh.nix
    ./agenix.nix
    # ./nvim.nix
    ./git.nix
    ./nix.nix
    ./helix.nix
    ./xdg-open.nix
    ./yazi.nix
    ./zellij.nix
    ./zoxide.nix
    ./direnv.nix
    ./nushell.nix
    ./starship.nix
    ./shell-aliases.nix
    ./neomutt.nix
    ./emails.nix
    ./mailcap.nix
    ./environment.nix
    ./rofi.nix
    ./application-theming.nix
    ./cava.nix
    ./taskwarrior.nix
    ./kdeconnect.nix
    ./zathura.nix
    ./carapace.nix
    ./nixvim.nix
    ./atuin.nix
    ./wezterm.nix
    # ./obs.nix
    ./xdg.nix
  ];
}
