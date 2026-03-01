{ pkgs, ... }:
{
  # disabledModules = [ "profiles/base.nix" ];

  time.timeZone = "Europe/Berlin";

  system.stateVersion = "25.05";

  services.displayManager = {
    enable = true;
    autoLogin.user = "autologin";
  };

  users = {
    users."autologin" = {
      isNormalUser = true;
      group = "autologin";
    };

    groups.autologin = { };
  };

  networking.firewall.enable = false;

  services.pipewire.enable = false;
  services.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    systemWide = true;
  };
}
