{ config, ... }: {
  imports = [ ./services ../../../baseline/packages.nix ./networking.nix ];
}
