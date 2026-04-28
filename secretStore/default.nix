{ ... }:
{
  keys = import ./pubkeys.nix;
  secrets = ./.;
  getServerSecrets = server: {
    getSecret = name: ./servers/${server}/${name}.age;
  };

  nonServer = ./non-server;
}
