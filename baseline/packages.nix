{
  pkgs
}:
{
  environment.systemPackages = with pkgs; [
    zsh
    vim
    wget
    btop
    bat
    gh
    git
    ripgrep
  ];
}
