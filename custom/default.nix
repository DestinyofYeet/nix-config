{ lib, ... }:
{
  wireguard = import ./wireguard.nix { };
  nebula = import ./nebula { inherit lib; };

  pubkeys = import ./pubkeys.nix;
}
