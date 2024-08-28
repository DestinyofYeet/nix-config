{
  pkgs,
  ...
}:
{
  programs.direnv.enable = true;

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
  ];
}
