{ ... }: {
  wayland.windowManager.sway = {
    enable = true;
    config = { startup = [{ command = "sunshine"; }]; };
  };
}
