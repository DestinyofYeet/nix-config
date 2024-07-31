{ pkgs, ... }: {
  stylix.enable = true;

  # stylix.targets.gnome.enable = false;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

  stylix.image = pkgs.fetchurl {
    url = "https://w.wallhaven.cc/full/qz/wallhaven-qzq1p5.jpg";
    sha256 = "sha256-iGVndavzet3G3NgpT8XGSDW6wi5eRD2SrwnJwsQqAUs=";
  };
}
