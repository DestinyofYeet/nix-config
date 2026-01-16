{ lib, osConfig, ... }:

let wallpaperPrimary = lib.custom.settings.non-server.background;
in {
  services.hyprpaper =
    lib.mkIf (!osConfig.capabilities.wallpaperEngine.enable) {
      enable = true;

      settings = {
        ipc = "on";
        splash = false;

        preload = [ (toString wallpaperPrimary) ];

        wallpaper = [ ",${toString wallpaperPrimary}" ];
      };
    };
}
