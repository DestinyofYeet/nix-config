{
  pkgs,
  config,
  lib,
  ...
}:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # nixpkgs.overlays = lib.mkIf (config.capabilities.customNixInterpreter.enable)
  #   [
  #     (final: prev: {
  #       inherit (prev.lixPackageSets.stable)
  #         nixpkgs-review nix-eval-jobs nix-fast-build colmena;
  #     })
  #   ];

  environment.systemPackages = with pkgs; [
    zsh
    vim
    wget
    btop
    bat
    git
    ripgrep
    fzf
    autoconf
    automake
    gcc
    gccgo
    gnumake
    unzip
    file
    lshw
    pciutils
    amdgpu_top
    radeontop
    deploy-rs
    helix
    dig
    glances
    wireguard-tools
    nix-output-monitor
    openssl
    ffmpeg
    iperf
    smartmontools
    dmidecode
    wezterm
    unixtools.netstat
    net-tools
    nmap
    tcpdump
  ];
}
