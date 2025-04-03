{ pkgs, lib, stable-pkgs, ... }: {
  system.nixos.tags = [ "de-hyprland" ];

  imports = [ ./japanese-keyboard.nix ./programs.nix ];

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
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-desktop-portal-hyprland
    ];

    xdgOpenUsePortal = true;
  };

  home-manager.extraSpecialArgs.current-specialisation = "de-hyprland";
  home-manager.users.ole = { ... }: { imports = [ ../../modules ./modules ]; };
}
