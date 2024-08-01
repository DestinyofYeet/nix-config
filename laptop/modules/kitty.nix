{ 
  pkgs, 
  ... 
}:
{
  programs.kitty = {
    enable = true;

    shellIntegration.enableBashIntegration = true;

    extraConfig = ''
      shell ${pkgs.zsh}/bin/zsh
      # shell ${pkgs.bash}/bin/bash
      editor vim

      shell_integration enabled no-cursor

      background_blur     30
      background_opacity  0.6

      enable_audio_bell   false
      cursor_shape        block

      map ctrl+space>1 goto_tab 1
      map ctrl+space>2 goto_tab 2
      map ctrl+space>3 goto_tab 3
      map ctrl+space>4 goto_tab 4
      map ctrl+space>5 goto_tab 5
      map ctrl+space>6 goto_tab 6
      map ctrl+space>7 goto_tab 7

      map ctrl+space>c  new_tab_with_cmd
    '';
  };
}
