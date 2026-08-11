{ config, lib, ... }:
{
  imports = [
    ./services
    ../../../baseline/packages.nix
    ./networking.nix
  ];

  capabilities = {
    customNixInterpreter.enable = false;
  };

  programs.nh.clean.enable = lib.mkForce false;

}
