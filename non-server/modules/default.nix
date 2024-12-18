{ ... }:
{
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
    ./xdg-open.nix
    ./yazi.nix
    ./fuck.nix
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
    ./hyprland.nix
    ./waybar.nix
    ./rofi.nix
    # ./hyprlock.nix
    ./hypridle.nix
    ./hyprpaper.nix
    # ./gnome-keyring.nix
    ./dunst.nix
    ./application-theming.nix
    ./cava.nix
    ./hyprsunset.nix
    ./taskwarrior.nix
    ./swaylock.nix
  ];
}
