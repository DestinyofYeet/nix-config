# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./networking.nix
      ./packages.nix
      ./services
      ./users.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  system.stateVersion = "24.05"; # Did you read the comment?

  services.qemuGuest.enable = true;

  nix.buildMachines = [
    {
      hostName = "uwuwhatsthis";
      system = "x86_64-linux";
      protocol = "ssh";
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
      maxJobs = 6;
      speedFactor = 1;
    }
  ];
}

