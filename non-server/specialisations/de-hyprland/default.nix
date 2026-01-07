{ pkgs, lib, stable-pkgs, ... }:
let specialisation = "de-hyprland";
in {
  system.nixos.tags = [ specialisation ];

  imports = [
    # ./japanese-keyboard.nix
    ./programs.nix
  ];

  security.pam.services.swaylock = { };
  services.gnome.gnome-keyring.enable = true;

  programs.hyprland = {
    # package = stable-pkgs.hyprland;
    enable = true;
  };

  programs.iio-hyprland.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  home-manager.extraSpecialArgs = { current-specialisation = specialisation; };
  home-manager.users.ole = { ... }: { imports = [ ../../modules ./modules ]; };
}
