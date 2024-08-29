# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  gaming-pkgs = with pkgs; [
    gamescope
    mangohud
    amdvlk
    gamemode
    vkbasalt
  ];
in
{
  nix.settings = {
      substituters = [
        "http://nix-server.infra.wg:5000?priority=30"
      ];

      trusted-public-keys = [
        "nix-server.infra.wg:6NVrebwBuWHxZx8PNXQwgBHamQer7VcMBYxerF/xvr8="
      ];
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  networking.extraHosts = ''
    192.168.0.248 nix-server.infra.wg
  '';

  programs.steam.extraPackages = gaming-pkgs;

  hardware.amdgpu.amdvlk.enable = true;

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    vulkan-tools
  ] ++ gaming-pkgs;
}
