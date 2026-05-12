{
  pkgs,
  ...
}:
{
  services.pipewire.enable = false;
  services.pulseaudio = {
    enable = true;
    systemWide = true;
    package = pkgs.pulseaudioFull;
  };
}
