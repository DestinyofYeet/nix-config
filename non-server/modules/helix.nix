{ pkgs, ... }:
{
  # home.file = {
  #   ".config/helix/config.toml" = {
  #     source = (pkgs.formats.toml { }).generate "config.toml" {
  #       theme = "material_deep_ocean";

  #       editor = {
  #         mouse = false;
  #       };
  #     };
  #   };

  #   ".config/helix/languages.toml" = {
  #     source = (pkgs.formats.toml {}).generate "languages.toml" {
  #       language-server = {
  #         rust-analyzer = {
  #           config = {
  #             procMacro.ignored.leptos_macro = [
  #               # "server"
  #               # "component"
  #             ];
  #           };
  #         };
  #       };
  #     };
  #   };
  # };

  programs.helix = {
    enable = true;

    defaultEditor = true;

    # languages = {
    #   language = [
    #     # {
    #     #   name = "markdown";
    #     #   language-server.command = "mdpls";

    #     #   config = {
    #     #     markdown.preview = {
    #     #       auto = true;
    #     #       browser = "firefox";
    #     #     };
    #     #   };
    #     # }
    #   ];
    # };

    settings = {
      theme = "material_deep_ocean";

      editor = {
        mouse = false;
      };
    };
  };
}
