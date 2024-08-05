
{ config, pkgs, ... }: {

  # zsh config
  environment.pathsToLink = [ "/share/zsh" ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    baloo # fuck this shit
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    firefox
    neovim
    asciiquarium
    cowsay
    zed-editor
    nixfmt-classic
    tlp
    zoxide
    xournalpp
    bitwarden-desktop
    vesktop
    brave
  ];
}
