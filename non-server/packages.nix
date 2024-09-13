
{ config, pkgs, ... }: let
  stable = import (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/51ab9e080fba4f75fb8a0f753c99e99801543519) { config = config.nixpkgs.config; };

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
  ];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;
  programs.firefox.enable = true;
  programs.neovim.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  programs.steam = {
    enable = true;
  };


  programs.noisetorch.enable = true;

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
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
    helix
    libreoffice-qt6-fresh
    vlc
    wl-clipboard
    openfortivpn
    openvpn
    nfs-utils
    mp3gain
    flac
    nmap
    brightnessctl
    feishin
    android-tools
    signal-desktop
    easyeffects
    keepassxc
    ffmpeg
    noto-fonts
    yubioath-flutter
    yubikey-manager-qt
    yubikey-personalization-gui
    nextcloud-client
    traceroute
    discord
    audacity
    gdb
    ventoy-full
    qbittorrent
    dig
  ] ++ lua-pkgs;
}

