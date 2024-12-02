{ 
  pkgs, 
  ... 
}:
{
  programs.kitty = {
    enable = true;

    shellIntegration.enableBashIntegration = true;
    shellIntegration.enableZshIntegration = true;


    extraConfig = ''
      font_family         Comic Code Ligatures
      # font_family         JetbrainsMono Nerd Font
      # font_family         auto
      bold_font           auto
      italic_font         auto
      bold_italic_font   auto

      shell ${pkgs.nushell}/bin/nu
      editor vim

      shell_integration enabled no-cursor

      background_blur     30
      background_opacity  0.6

      enable_audio_bell   false

      cursor_shape        block
      cursor_blink_interval 0.5 ease-in-out

      map ctrl+space>1 goto_tab 1
      map ctrl+space>2 goto_tab 2
      map ctrl+space>3 goto_tab 3
      map ctrl+space>4 goto_tab 4
      map ctrl+space>5 goto_tab 5
      map ctrl+space>6 goto_tab 6
      map ctrl+space>7 goto_tab 7

      map ctrl+space>c  new_tab_with_cwd

      tab_bar_min_tabs  1
      tab_bar_edge      bottom
      tab_bar_style     powerline
      tab_title_template {title}{' :{}:'.format(num_windows) if num_windows > 1 else ' '}
    '';
  };
}
