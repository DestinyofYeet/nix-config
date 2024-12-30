{
  pkgs,
  ...
}:{
  home.file = {
    ".config/hypr/pyprland.toml".source = pkgs.writers.writeTOML "pyprland.toml" {
      pyprland = {
        plugins = [
          "fetch_client_menu"
        ];

        fetch_client_menu = {
          engine = "anyrun";
        };
      };
    };
  };
}
