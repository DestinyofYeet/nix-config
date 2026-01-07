{ lib, pkgs, ... }: {

  xdg.portal = {
    enable = true;

    xdgOpenUsePortal = true;

    extraPortals = (with pkgs; [
      xdg-desktop-portal-gtk
      gnome-keyring
      xdg-desktop-portal-wlr
    ]);
    config.common.default = "*";
  };
}
