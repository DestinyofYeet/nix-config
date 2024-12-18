{ lib, pkgs, ... }:
{
  programs.rofi = {
    enable = true;

    location = "top";

    terminal = "${pkgs.kitty}/bin/kitty";

    package = pkgs.rofi-wayland;

    theme = lib.mkForce ./rofi-themes/rounded-blue-dark.rasi;
  };
}
