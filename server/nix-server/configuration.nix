# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ./networking.nix
    ./system_packages.nix
    ./system_users.nix
    ./nvidia.nix
    ./services
    ./scripts
    ./vms
  ];

  system.stateVersion = "24.05"; # Did you read the comment?

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "ole" "root" ];
      substituters = [ "https://cache.ole.blue?priority=20" ];

      trusted-public-keys =
        [ "cache.ole.blue:UB3+v071mF6riM4VUYqJxBRjtrCHWFxeGMzCMgxceUg=" ];
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "de";

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  boot.supportedFilesystems = [ "zfs" ];

  networking.hostId = "170d9b6c";

  networking.hostName = "nix-server";

  environment.etc."current-system-packages".text = let
    packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
    sortedUnique =
      builtins.sort builtins.lessThan (pkgs.lib.lists.unique packages);
    formatted = builtins.concatStringsSep "\n" sortedUnique;
  in formatted;
}
