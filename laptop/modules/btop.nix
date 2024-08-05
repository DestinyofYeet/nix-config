{ ... }: {
  programs.btop = {
    enable = true;

    settings = {
      truecolor = true;
      update_ms = 1000;
      proc_sorting = "cpu direct";
    };
  };
} 
