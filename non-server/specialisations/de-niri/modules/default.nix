{
  ...
}:
let
  waybar = import ../../hm-common/waybar.nix {
    workspaces = "niri/workspaces";
    target = "graphical-session.target";
  };
in
{
  imports = [
    ./gnome-keyring.nix
    ./niri.nix
    ./dunst.nix
    ./redshift.nix
    # ./wallpaperengine.nix
    # ./swaylock.nix
    ../../hm-common/cursor.nix
    ../../hm-common/gnome-keyring.nix
    ./swayidle.nix
    # waybar
    ./nushell.nix
    # ./swaybg.nix
    ./noctalia.nix
  ];
}
