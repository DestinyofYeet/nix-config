{ config, pkgs, stable-pkgs, old-pkgs, lib, inputs, ... }:
let
  luaPkgs = with pkgs; [ luajitPackages.luarocks lua luajit ];

  kdePkgs = with pkgs.kdePackages; [
    kcalc
    kparts
    svgpart
    markdownpart
    konversation
    krdc
    krdp
    dolphin
  ];

  jetbrainsPkgs = with pkgs.jetbrains; [ rust-rover pycharm-professional ];

  pythonPkgs = with pkgs.python312Packages; [ python-lsp-server pyclip ];

  nerd-fontsPkgs =
    builtins.filter lib.isDerivation (builtins.attrValues pkgs.nerd-fonts);
in {
  hardware.flipperzero.enable = true;

  # zsh config
  environment.pathsToLink = [ "/share/zsh" ];

  # environment.plasma6.excludePackages = with pkgs.kdePackages; [ plasma-browser-integration ];

  fonts = { packages = with pkgs; [ noto-fonts-cjk-serif ] ++ nerd-fontsPkgs; };

  nixpkgs = {
    config = {
      permittedInsecurePackages = [
        "electron-31.7.7"
        "ventoy-1.1.05"
        "dotnet-sdk-6.0.428" # eddie
        "dotnet-runtime-6.0.36" # eddie
        # "qtwebengine-5.15.19" # jellyfin-media-player
        "ventoy-1.1.07"
      ];
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
  };

  programs.zsh.enable = true;
  programs.firefox.enable = true;
  programs.neovim.enable = true;

  virtualisation.waydroid.enable = true;

  # programs.ssh.startAgent = true;

  programs.corectrl = { enable = true; };

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  programs.steam = {
    enable = true;
    # package = pkgs.steam.override {
    #   extraPkgs = pkgs: with pkgs; [ bumblebee glxinfo ];
    # };
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [ obs-backgroundremoval ];
  };

  programs.noisetorch.enable = true;

  programs.adb.enable = true;

  services.mysql.package = pkgs.mariadb;

  # programs.hyprland = {
  #   enable = true;
  #   withUWSM = true;
  # };

  # programs.hyprlock.enable = true;
  # security.pam.services.hyprlock = { };

  # security.pam.services.swaylock = { };

  # services.gnome.gnome-keyring.enable = true;

  programs.wshowkeys = { enable = true; };

  services.flatpak = {
    enable = true;
    remotes = [{
      name = "flathub";
      location = "https://flathub.org/repo/flathub.flatpakrepo";
    }];

    packages = [
      # { # signal
      #   flatpakref =
      #     "https://dl.flathub.org/repo/appstream/org.signal.Signal.flatpakref";
      #   sha256 = "06hi4fpqdq8qkn1bdilsy5h04sg69f25y6l0dj5mcrrxcvhgh5jf";
      # }
      { # rnote
        flatpakref =
          "https://dl.flathub.org/repo/appstream/com.github.flxzt.rnote.flatpakref";
        sha256 = "0askvqc9i9rnd924gij8d4q5wpdih8c90vqh718sqd94zkv0p5k4";
      }
      { # flatseal
        flatpakref =
          "https://dl.flathub.org/repo/appstream/com.github.tchx84.Flatseal.flatpakref";
        sha256 = "00kvi432gdrhyyhz34vs00398c77lzji1qgvchfrs1kxxp84bbbi";
      }
    ];
  };

  environment.systemPackages = with pkgs;
    [
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
      # jellyfin-media-player # depending on qtwebengine, which is broken
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
      yubikey-manager
      # yubikey-personalization-gui // archived upstream
      yubikey-personalization
      # stable-pkgs.nextcloud-client
      traceroute
      discord
      audacity
      gdb
      ventoy-full
      qbittorrent
      dig
      old-pkgs.freerdp3
      cifs-utils
      samba
      keyutils
      lua-language-server
      clang-tools
      rust-analyzer
      # nil
      nixd
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
      stable-pkgs.gimp-with-plugins
      stable-pkgs.rpi-imager
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
      # colmena
      poppler
      recyclarr
      # inputs.mdpls-nix.packages.x86_64-linux.default
      playerctl
      pavucontrol
      blueman
      libsecret
      networkmanagerapplet
      libnotify
      hyprpaper
      hyprshot
      hyprsunset
      sbctl
      lm_sensors
      saber
      taskwarrior3
      timewarrior
      taskwarrior-tui
      nixfmt-rfc-style
      filezilla
      mpv
      wirelesstools
      inetutils
      krita
      (lib.mkIf (config.networking.hostName != "wattson") aseprite)
      # pyprland
      qFlipper
      yt-dlp
      typescript-language-server
      obsidian
      cavalier
      nebula
      prismlauncher
      alejandra
      hunspell
      hunspellDicts.de_DE
      satty
      grim
      slurp
      shotcut
      nix-search-cli
      udiskie
      hugo
      ripgrep-all
      teams-for-linux
      plantuml
      git-lfs
      feh
      caligula
      presenterm
      python313Packages.weasyprint
      clippy # rust check
      serpl
      cgdb
      # eddie
      moonlight-qt
      tidal-dl
      tokei
      eduvpn-client
      inputs.fladder-nix.packages.x86_64-linux.default
      nb
      inputs.tiddl-nix.packages.x86_64-linux.default
      gnome-disk-utility
      bluetui
      logiops
    ] ++ luaPkgs ++ kdePkgs ++ jetbrainsPkgs ++ pythonPkgs;
}
