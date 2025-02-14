{...}: {
  keys = import ./pubkeys.nix;
  secrets = ./.;
}
