{ ... }:
{
  programs.cava = {
    enable = true;

    settings = {
      general = {
        framerate = 60;

        bars = 512;
      };

      input.method = "pipewire";

      colors = {
        # background = "'2864FF'";
        foreground = "'#2864FF'";
        # gradient_count = 2;
        # gradient_color_1 = "#2864FF";
        # gradient_color_2 = "#C620FF";
      };
    };
  };
}
