{ flake, lib, ... }:
let
  buildSSHDomains = nodes:
    builtins.concatStringsSep "\n" (map (name: ''
      { name = "${name}",
       remote_address = "${nodes.${name}.hostname}",
       username = "${nodes.${name}.profiles.system.sshUser}",
       },'') (lib.mapAttrsToList (name: value: name) nodes));
in {
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
        top = 0,
      }

      config.animation_fps = 30
      config.default_cursor_style = 'BlinkingBlock'
      config.cursor_blink_ease_in = 'EaseIn'
      config.cursor_blink_ease_out = 'EaseOut'

      config.ssh_domains = {
        ${buildSSHDomains flake.deploy.nodes}
      }

      config.mouse_bindings = {
        {
          event = { Down = { streak = 1, button = { WheelUp = 1 } } },
          mods = 'NONE',
          action = act.ScrollByLine(-3),
        },
        {
          event = { Down = { streak = 1, button = { WheelDown = 1 } } },
          mods = 'NONE',
          action = act.ScrollByLine(3),
        },
      }

      config.leader = { key = 'Space', mods = 'CTRL', timeout_milliseconds = 1000 }

      config.keys = {
        {
          key = 'c',
          mods = 'LEADER',
          action = act.SpawnTab 'CurrentPaneDomain',
        },
        {
          key = ",",
          mods = "SHIFT|CTRL",
          action = act.MoveTabRelative(-1),
        },
        {
          key = ".",
          mods = "SHIFT|CTRL",
          action = act.MoveTabRelative(1),
        },
      }

      for i = 1, 9 do
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
