{ lib, ... }:

let
  wallpaperPrimary = lib.custom.settings.non-server.background;
in
{
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;

      preload = [ (toString wallpaperPrimary) ];

      wallpaper = [ ",${toString wallpaperPrimary}" ];
    };
  };
}
