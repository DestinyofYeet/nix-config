
{ config, pkgs, ... }: {

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
		firefox
    btop
    neovim
    asciiquarium
    cowsay
    zed-editor
    bat
    nixfmt-classic
    gh
    git
  ];
}
