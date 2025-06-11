{ lib, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";
      terminal = "wezterm";
      output."*" = lib.mkForce { };
      input."*".xkb_layout = "de";
    };
  };
}
