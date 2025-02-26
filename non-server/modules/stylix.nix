{
  pkgs,
  config,
  lib,
  ...
}:
let
  read_color = builtins.readFile ./current_color.txt;
  current_color = pkgs.lib.removeSuffix "\n" read_color;
in
{
  stylix.enable = true;

  # me likey
  # catppucin-frappe
  # nebula
  # tokyo-night-terminal-dark
  # synth-midnight-dark
  # tokyo-city-dark
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
  #
  # stylix.image = pkgs.fetchurl {
  #   url = "https://w.wallhaven.cc/full/qz/wallhaven-qzq1p5.jpg";
  #   sha256 = "sha256-iGVndavzet3G3NgpT8XGSDW6wi5eRD2SrwnJwsQqAUs=";
  # };

  # Set the same image as in kde, to avoid some wierd background behaviour
  stylix.image = lib.custom.settings.non-server.background;

  stylix.targets = {
    kde.enable = false;
    kitty = {
      enable = true;
      variant256Colors = true;
    };

    hyprland.enable = false;
    hyprpaper.enable = false;
    hyprlock.enable = false;

    helix.enable = false;

    waybar.enable = false;

    rofi.enable = false;

    swaylock.enable = false;

    vim.enable = false;
    neovim.enable = false;
    nixvim.enable = false;
  };
}
