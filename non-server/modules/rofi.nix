{ lib, pkgs, ... }: {
  programs.rofi = {
    enable = true;

    location = "top";

    terminal = "${pkgs.kitty}/bin/kitty";

    theme = lib.mkForce ./rofi-themes/rounded-blue-dark.rasi;
  };
}
