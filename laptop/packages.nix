
{ config, pkgs, ... }: let
  # unstable = import (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/d3f42bd62aa840084563e3b93e4eab73cb0a0448) { config = config.nixpkgs.config; };

  lua-pkgs = with pkgs; [
    luajitPackages.luarocks
    lua
    luajit
  ];
in
  {

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
    innernet
    rustup
    jetbrains-toolbox
    jellyfin-media-player
    wireguard-tools
    monero-gui
    fd
    tree-sitter
    nodePackages.nodejs
    nerdfonts
    ungoogled-chromium
    magic-wormhole-rs
    element-desktop
    python3
  ] ++ lua-pkgs;
}
