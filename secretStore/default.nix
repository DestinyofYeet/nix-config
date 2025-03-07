{ ... }: {
  keys = import ./pubkeys.nix;
  secrets = ./.;
  get-server-secrets = name: ./servers/${name};
}
