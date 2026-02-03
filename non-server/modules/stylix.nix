{ pkgs, config, lib, ... }: {
  stylix.enable = true;

  # me likey
  # catppucin-frappe
  # nebula
  # tokyo-night-terminal-dark
  # synth-midnight-dark
  # tokyo-city-dark
  stylix.base16Scheme =
    "${pkgs.base16-schemes}/share/themes/tokyo-night-terminal-dark.yaml";
  #
  # stylix.image = pkgs.fetchurl {
  #   url = "https://w.wallhaven.cc/full/qz/wallhaven-qzq1p5.jpg";
  #   sha256 = "sha256-iGVndavzet3G3NgpT8XGSDW6wi5eRD2SrwnJwsQqAUs=";
  # };

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
    firefox.enable = false;

    yazi.enable = false;
    ashell.enable = false;
  };
}
