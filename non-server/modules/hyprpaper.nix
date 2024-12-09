{
  ...
}:

let
  wallpaperPrimary = ../../images/wallhaven-nightsky.jpg;
in {
  services.hyprpaper = {
    enable = true;

    settings = {
      ipc = "on";
      splash = false;

      preload = [
        (toString wallpaperPrimary)
      ];

      wallpaper = [
        ",${toString wallpaperPrimary}"
      ];
    };
  };
}
