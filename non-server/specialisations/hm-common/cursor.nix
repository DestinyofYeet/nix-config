{
  pkgs,
  lib,
  ...
}:
{
  home.pointerCursor = lib.mkForce {
    enable = true;

    # fuckoff stylix
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;

    gtk.enable = true;
  };
}
