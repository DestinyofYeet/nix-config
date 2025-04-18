# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "main"; # Define your hostname.

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-amd"
    "zenpower"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zenpower ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3b3ee9fb-0791-4926-a9a8-60cb2c2ae817";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-44f7c688-feba-4e85-96e3-84d903018204".device =
    "/dev/disk/by-uuid/44f7c688-feba-4e85-96e3-84d903018204";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/642E-C7CB";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # fixes SteamVR for some reason
  # hardware.amdgpu.amdvlk.enable = true;

  fileSystems = {
    "/drives/navidrome" = {
      device = "192.168.1.1:/mnt/data/data/media/navidrome";
      fsType = "nfs";
      options = [
        "hard"
        "intr"
        "nofail"
      ];
    };

    "/drives/langsames_drecks_ding2" = {
      device = "/dev/disk/by-uuid/f5674361-378c-410d-a600-8ebe8b5056dd";
      fsType = "btrfs";
      options = [ "nofail" ];
    };

    "/drives/programming-Stuff" = {
      device = "192.168.1.1:/mnt/data/data/programmingStuff";
      fsType = "nfs";
      options = [
        "hard"
        "intr"
        "nofail"
      ];
    };
  };

  systemd.services = {
    fix-sleep-issue = {
      description = "Fix the sleep issue on my motherboard";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.bash}/bin/sh -c 'echo GPP0 > /proc/acpi/wakeup'";
      };
    };
  };
}
