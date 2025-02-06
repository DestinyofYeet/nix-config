{
  pkgs,
  lib,
  ...
}: {
  gtk = rec {
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = gtk3.extraConfig;
  };

  qt = {
    enable = true;

    platformTheme.name = lib.mkForce "qt5ct";

    # style.name = lib.mkForce "kvantum";
    # style = {
    #   name = "Catppuccin";
    #   package = pkgs.catppuccin;
    # };
  };

  xdg.configFile = {
    "Kvantum/Catppuccin-Macchiato-Blue/Catppuccin-Macchiato-Blue/Catppuccin-Macchiato-Blue.kvconfig".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Macchiato-Blue/Cattpuccin-Macchiato-Blue.kvconfig";
    "Kvantum/Catppuccin-Macchiato-Blue/Catppuccin-Macchiato-Blue/Catppuccin-Macchiato-Blue.svg".source = "${pkgs.catppuccin-kvantum}/share/Kvantum/Catppuccin-Macchiato-Blue/Cattpuccin-Macchiato-Blue.svg";
  };
}
