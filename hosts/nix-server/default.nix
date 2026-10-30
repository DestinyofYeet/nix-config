{ inputs, ... }:
{
  imports = [
    ../../baseline
    ./configuration.nix
    ./acls.nix
  ];
}
