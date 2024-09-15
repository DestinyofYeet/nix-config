{
  pkgs,
  ...
}:{
  home.file = {
    ".config/mimeapps.list" = {
      source = (pkgs.formats.toml { }).generate "mimeapps.list" {
        "Default Applications" = {
          "x-scheme-handler/bitwarden"     = "Bitwarden.desktop";
          "x-scheme-handler/sgnl"          = "signal-desktop.desktop";
          "x-scheme-handler/signalcaptcha" = "signal-desktop.desktop";
          "x-scheme-handler/https"         = "firefox.desktop";
          "x-scheme-handler/http"          = "firefox.desktop";
        };
      };
    };
  };
}
