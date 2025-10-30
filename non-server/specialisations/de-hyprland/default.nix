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
    withUWSM = true;
  };

  programs.uwsm.enable = true;
  programs.iio-hyprland.enable = true;

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-termfilechooser
      xdg-desktop-portal-hyprland
    ];

    xdgOpenUsePortal = true;

    config = {
      common = { default = [ "hyprland" ]; };
      hyprland = {
        default = [ "hyprland" ];
        "org.freedesktop.impl.portal.FileChooser" =
          [ "xdg-desktop-portal-termfilechooser" ];
      };
    };
  };

  home-manager.extraSpecialArgs.current-specialisation = specialisation;
  home-manager.users.ole = { ... }: { imports = [ ../../modules ./modules ]; };
}
