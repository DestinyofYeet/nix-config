{ ... }:
{
  services.dunst = {
    enable = true;

    settings = {
      global = {
        fullscreen = "pushback";

        # mouse_left_click = "do_action, close_current";
        # mouse_right_click = "close_all";
      };
    };
  };
}
