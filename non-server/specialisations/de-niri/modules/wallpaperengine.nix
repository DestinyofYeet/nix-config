{ lib, osConfig, ... }:
lib.mkIf (osConfig.capabilities.wallpaperEngine.enable) {

  home.file.".cache/noctalia/wallpapers.json" = lib.mkForce { };

  services.linux-wallpaperengine =
    let
      mkIgnoreSteamApps =
        apps: builtins.concatStringsSep " " (map (app: "--fullscreen-pause-ignore-appid ${app}") apps);

      ignoredSteamApps = (mkIgnoreSteamApps [ ]);
    in
    {
      enable = true;
      assetsPath = "/home/ole/.steam/steam/steamapps/common";

      wallpapers = [
        {
          wallpaperId = "878654942";
          extraOptions = [
            ignoredSteamApps
          ];
          monitor = "DP-2";
        }
        {

          wallpaperId = "876411152";
          monitor = "DP-3";
          extraOptions = [
            "--fullscreen-pause-only-active"
            ignoredSteamApps
          ];
          audio.silent = true;
        }
      ];
    };

  systemd.user.services.linux-wallpaperengine.Service.Environment = [ "XDG_SESSION_TYPE=wayland" ];
}
