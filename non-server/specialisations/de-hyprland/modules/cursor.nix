{
  pkgs,
  lib,
  ...
}:
{
  home.pointerCursor = lib.mkForce {
    # fuckoff stylix
    name = "Posy_Cursor_Black";
    package = pkgs.posy-cursors;

    gtk.enable = true;
  };
}
