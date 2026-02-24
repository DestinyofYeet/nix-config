{
  ...
}:
let
  waybar = import ../../common/waybar.nix {
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
    ./wallpaperengine.nix
    ./swaylock.nix
    waybar
  ];
}
