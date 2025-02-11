{...}: {
  wireguard = import ./wireguard.nix {};
  nebula = import ./nebula;
}
