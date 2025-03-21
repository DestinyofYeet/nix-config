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
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ata_piix"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/e44f2f50-1b93-4e05-b232-9161b34ef38f";
    fsType = "ext4";
  };

  boot.initrd.luks.devices."luks-93803302-ca17-49c4-964b-68f442be0da7".device =
    "/dev/disk/by-uuid/93803302-ca17-49c4-964b-68f442be0da7";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/9C45-95ED";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/5194eb93-bdeb-4c10-81e9-81b92b9eb16f"; }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-00ba3420-d5f8-4549-807e-720f4a3df6d1".device =
    "/dev/disk/by-uuid/00ba3420-d5f8-4549-807e-720f4a3df6d1";
  networking.hostName = "kartoffelkiste"; # Define your hostname.
}
