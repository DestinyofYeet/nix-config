{...}: {
  wireguard = import ./wireguard.nix {};
  nebula = import ./nebula {};

  pubkeys = import ./pubkeys.nix;
}
