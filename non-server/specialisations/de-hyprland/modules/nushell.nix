{...}: {
  programs.nushell = {
    configFile.text = ''
      def tv-enable [] {
        hyprctl keyword monitor "HDMI-A-1, 1280x720@60, 0x1080, 1"
      }

      def tv-disable [] {
        hyprctl keyword monitor "HDMI-A-1, disable"
      }

      def screens-mirror [] {
        hyprctl keyword monitor ", preferred, auto, 1, mirror, eDP-1"
      }

      def screens-extend [] {
        hyprctl keyword monitor ", preferred, auto, 1"
      }
    '';
  };
}
