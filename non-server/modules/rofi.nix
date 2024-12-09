{
  lib,
  pkgs,
  ...
}:{
  programs.rofi = {
    enable = true;

    location = "center";

    terminal = "${pkgs.kitty}/bin/kitty";

    theme = lib.mkForce ./rofi-themes/tokyo-night.rasi;
  };
}
