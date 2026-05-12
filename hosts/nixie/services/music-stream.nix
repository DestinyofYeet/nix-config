{
  ...
}:
{
  networking.firewall.enable = false;

  # services.squeezelite = {
  #   enable = true;
  #   name = "Anlage";
  #   extraArgs = ''
  #     -O sysdefault:CARD=Headphones
  #   '';
  # };

  services.shairport-sync = {
    enable = true;
    settings = {
      general = {
        name = "Anlage";
        output_backend = "pulseaudio";
        mdns_backend = "tinysvcmdns";
      };
    };
  };

  systemd.services.shairport-sync.serviceConfig.SupplementaryGroups = [ "pulse-access" ];
}
