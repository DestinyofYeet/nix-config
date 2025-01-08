{ pkgs, ... }:
{

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    zsh
    vim
    wget
    btop
    bat
    gh
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
  ];
}
