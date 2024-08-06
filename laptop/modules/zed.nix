{ config, ... }:
  let dirs = import { inherit config; };
{
  home.file = {
    "${dirs.home.config.zed}/settings.json" = {
      text = ''
      {
        "vim_mode": true;
        "ui_font_size": 16,
        "buffer_font_size": 16,
        "theme": {
          "mode": "system",
          "light": "One Light",
          "dark": "Catppuccin Mocha"
        },
        "autosave": {
          "after_delay": {
            "milliseconds": 500,
          }
        },

        "auto_update": false,
      }
      '';
    };
  };
}
