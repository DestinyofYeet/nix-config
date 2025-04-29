{ ... }: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config = wezterm.config_builder()
      local act = wezterm.action

      config.font = wezterm.font "Comic Code Ligatures"
      config.color_scheme = "Tokyo Night Moon"
      config.window_background_opacity = 0.6

      config.window_padding = {
        left = 0,
        right = 0,
        bottom = 0,
      }

      config.animation_fps = 30
      config.default_cursor_style = 'BlinkingBlock'
      config.cursor_blink_ease_in = 'EaseIn'
      config.cursor_blink_ease_out = 'EaseOut'

      config.ssh_domains = {
        {
          name = "teapot",
          remote_address = "teapot",
          username = "root",
        },
      }

      config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 300 }

      config.keys = {
        {
          key = 'c',
          mods = 'LEADER',
          action = act.SpawnTab 'CurrentPaneDomain',
        },
      }

      for i = 1, 8 do
        -- ctrl + space + i -> Tab
        table.insert(config.keys, {
          key = tostring(i),
          mods = 'LEADER',
          action = act.ActivateTab(i - 1),
        })
      end

      return config
    '';
  };
}
