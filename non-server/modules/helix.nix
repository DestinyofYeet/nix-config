{
  pkgs,
  ...
}:{
  home.file = {
    ".config/helix/config.toml" = {
      source = (pkgs.formats.toml { }).generate "config.toml" {
        theme = "material_deep_ocean";
      };
    };
  };
}
