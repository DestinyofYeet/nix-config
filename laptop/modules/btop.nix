{ ... }: {
  programs.btop = {
    enable = true;

    settings = {
      truecolor = true;
      color_theme = "HotPurpleTrafficLight";
      theme_background = true;
      update_ms = 1000;
      proc_sorting = "cpu responsive";
    };
  };
} 
