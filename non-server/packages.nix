
{ config, pkgs, stable-pkgs, lib, inputs, ... }: let

  luaPkgs = with pkgs; [
    luajitPackages.luarocks
    lua
    luajit
  ];

  kdePkgs = with pkgs.kdePackages; [
    kcalc
    kparts
    svgpart
    markdownpart
    konversation
    krdc
    krdp
  ];

  jetbrainsPkgs = with pkgs.jetbrains; [
    rust-rover
    pycharm-professional
  ];

  pythonPkgs = with pkgs.python312Packages; [
    python-lsp-server
    pyclip
  ];

  nerd-fontsPkgs = builtins.filter lib.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  
  in {

  # zsh config
  environment.pathsToLink = [ "/share/zsh" ];

  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
  ];

  fonts = {
    packages = [
      
    ] ++ nerd-fontsPkgs;
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.nvidia.acceptLicense = true;

  programs.zsh.enable = true;
  programs.firefox.enable = true;
  programs.neovim.enable = true;

  virtualisation.waydroid.enable = true;

  # programs.ssh.startAgent = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  programs.steam = {
    enable = true;
    # package = pkgs.steam.override {
    #   extraPkgs = pkgs: with pkgs; [ bumblebee glxinfo ];
    # };
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-backgroundremoval
    ];
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback video_nr=10 card_label=Video-Loopback exclusive_caps=1
  '';


  programs.noisetorch.enable = true;

  programs.adb.enable = true;

  programs.hyprland.enable = true;

  programs.hyprlock.enable = true;

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    asciiquarium
    cowsay
    zed-editor
    nixfmt-classic
    tlp
    zoxide
    xournalpp
    # bitwarden-desktop
    vesktop
    brave
    innernet
    rustup
    jellyfin-media-player
    wireguard-tools
    monero-gui
    fd
    tree-sitter
    nodePackages.nodejs
    ungoogled-chromium
    magic-wormhole-rs
    element-desktop
    python3
    helix
    stable-pkgs.libreoffice-qt6-fresh
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
    stable-pkgs.freerdp3
    cifs-utils
    samba
    keyutils
    lua-language-server
    clang-tools
    rust-analyzer
    nil
    bash-language-server
    trunk
    vscode-langservers-extracted
    keymapp
    tree
    mutt
    whois
    # rnote
    maliit-keyboard
    thunderbird
    d2
    gimp-with-plugins
    rpi-imager
    zoom-us
    texliveFull
    inkscape-with-extensions
    texlab
    tinymist
    typst
    lolcat
    tor-browser
    anki-bin
    tldr
    authenticator
    lutris
    waydroid
    lzip
    deluge-gtk
    nix-diff
    mailcap
    lynx
    youtube-music
    pdftk
    lldb_19
    nix-output-monitor
    nvtopPackages.full
    pueue
    colmena
    poppler
    recyclarr
    inputs.mdpls-nix.packages.x86_64-linux.default
    playerctl
    pavucontrol
    blueman
    libsecret
    networkmanagerapplet
    libnotify
    hyprpaper
    hyprshot
    hyprsunset
  ] ++ luaPkgs ++ kdePkgs ++ jetbrainsPkgs ++ pythonPkgs;
}

