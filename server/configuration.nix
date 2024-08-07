# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    # No touchey !!!
    # Since Nix runs in a systemd-nspawn environment, it doesn't boot without this
    "${modulesPath}/virtualisation/lxc-container.nix"
    # No touchey end

    ./system_networking.nix
    ./system_packages.nix
    ./system_users.nix
    ./system_services.nix
    ./services
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs;
    [
      # Add any missing dynamic libraries for unpackages programs here, not in environment.systemPackages
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "nix-server";
}
