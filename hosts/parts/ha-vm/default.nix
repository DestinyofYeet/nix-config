{ config, ... }:
{
  imports = [
    ./services
    ../../../baseline/packages.nix
    ./networking.nix
  ];

  capabilities = {
    customNixInterpreter.enable = false;
  };

}
