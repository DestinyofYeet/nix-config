{ ... }:
rec {
  keys = import ./pubkeys.nix;
  secrets = ./.;
  getServerSecrets = getHostSecrets;

  getHostSecrets = host: {
    getSecret = name: ./hosts/${host}/${name}.age;
  };

  nonServer = ./non-server;
}
