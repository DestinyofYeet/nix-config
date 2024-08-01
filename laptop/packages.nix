
{ config, pkgs, ... }: {

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
  ];
}
