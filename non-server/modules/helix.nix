{
  pkgs,
  ...
}:{
  home.file = {
    ".config/helix/config.toml" = {
      source = (pkgs.formats.toml { }).generate "config.toml" {
        theme = "material_deep_ocean";

        editor = {
          mouse = false;
        };
      };
    };

    ".config/helix/languages.toml" = {
      source = (pkgs.formats.toml {}).generate "languages.toml" {
        language-server = {
          rust-analyzer = {
            config = {
              procMacro.ignored.leptos_macro = [
                # "server"
                # "component"
              ];
            };
          };
        };
      };
    };
  };
}
