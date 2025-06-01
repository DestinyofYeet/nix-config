{ ... }: rec {
  keys = import ./pubkeys.nix;
  secrets = ./.;
  get-server-secrets = name: ./servers/${name};
  getServerSecrets = get-server-secrets;
}
