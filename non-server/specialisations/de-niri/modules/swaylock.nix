{ pkgs, lib, ... }:
{
  programs.swaylock = {
    enable = true;

    package = pkgs.swaylock-effects;

    settings = {
      daemonize = true;
      indicator = true;
      clock = true;

      # screenshots = true;
      # effect-blur = "11x11";

      image = lib.custom.settings.non-server.lock-screen;
      font = "JetBrains Mono";
      indicator-radius = 80;
      indicator-thickness = 8;
      timestr = "%H:%M";
      datestr = "%a %d.%m.%Y";

      inside-color = "#181926";
      ring-color = "#8bd5ca";
      key-hl-color = "#a6da95";
      text-color = "#cad3f5";
      layout-text-color = "#cad3f5";
      layout-bg-color = "#181926";
      text-caps-lock-color = "#cad3f5";

      inside-clear-color = "#f4dbd6";
      ring-clear-color = "#f0c6c6";
      text-clear-color = "#1e2030";

      inside-ver-color = "#91d7e3";
      ring-ver-color = "#7dc4e4";
      text-ver-color = "#1e2030";

      inside-wrong-color = "#ee99a0";
      ring-wrong-color = "#ed8796";
      text-wrong-color = "#1e2030";

      # grace-no-mouse = true;
      # grace-no-touch = true;
      grace = 2;
    };
  };
}
