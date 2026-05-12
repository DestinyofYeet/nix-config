{ pkgs, ... }:
{
  # disabledModules = [ "profiles/base.nix" ];

  time.timeZone = "Europe/Berlin";

  system.stateVersion = "25.05";

  networking.firewall.enable = false;

  services.getty = {
    autologinUser = "autologin";
  };

  programs.bash.enable = true;

  users = {
    users."autologin" = {
      isNormalUser = true;
      extraGroups = [
        "audio"
        "video"
      ];
    };

  };
}
