{ lib, ... }: {

  imports = [
    ../parts/ha-vm/services
    ../../baseline
    ./services
    ./hardware.nix
  ];

  system.stateVersion = "26.05";
  networking = {
    hostName = "fate";
    networkmanager.enable = true;
  };

  console.keyMap = "de";

  services.smartd.enable = lib.mkForce false;
}
