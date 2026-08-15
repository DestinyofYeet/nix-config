{ ... }: {
  imports = [
    # ../parts/ha-vm
    # ../../baseline/nebula.nix
    ./services
    ./hardware.nix
    ./configuration.nix
  ];

}
