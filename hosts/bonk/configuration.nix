# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./networking.nix
    ./services
    ./vms
    ../parts/idpDnsCert.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/Berlin";

  users = {

    users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFyr6IgLu/ucNhN533GkHyL7DFrzA9CTIFx7wBHY6Ufv ole@main"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILJ2++q6nzua4UrHFNjYwO7sGjru4QbY+m2lkciaXDX0 ole@wattson"
        ];
      };

      nixremote = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDcNdn73knzFAD3n1HVCQJq5DcQ9SOD2Yu27ZrlvbYSE root@teapot"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvtzIO9VDeJHgugOut5XWoUn6dQsEuxMXzQJfF+pe2M root@wattson"
        ];

        group = "nixremote";
      };
    };

    groups = { nixremote = { }; };
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

  documentation = {
    enable = false;
    man.generateCaches = false;
  };

  nix.settings.trusted-users = [ "nixremote" ];
}

