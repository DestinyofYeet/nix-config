{ ... }:
{
  programs.ghostty = {
    enable = true;

    systemd.enable = true;

    settings = {
      font-family = "Comic Code";

      background-opacity = 0.85;
      background-blur = true;

      cursor-style-blink = true;
    };
  };
}
