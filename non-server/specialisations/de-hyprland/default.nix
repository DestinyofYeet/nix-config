{
  pkgs,
  lib,
  stable-pkgs,
  ...
}:
{
  system.nixos.tags = [ "de-hyprland" ];
  security.pam.services.swaylock = { };
  services.gnome.gnome-keyring.enable = true;

  programs.hyprland = {
    # package = stable-pkgs.hyprland;
    enable = true;
    withUWSM = true;
  };

  programs.uwsm.enable = true;
  programs.iio-hyprland.enable = true;

  qt.platformTheme = "qt5ct";

  # xdg.portal = {
  #   xdgOpenUsePortal = true;

  #   config.common.default = [
  #     "gtk"
  #     "hyprland"
  #   ];

  #   extraPortals = [
  #     pkgs.xdg-desktop-portal-gtk
  #     pkgs.xdg-desktop-portal-hyprland
  #   ];
  # };

  home-manager.extraSpecialArgs.current-specialisation = "de-hyprland";
  home-manager.users.ole =
    { ... }:
    {
      imports = [
        ../../modules
        ./modules
      ];
    };
}
