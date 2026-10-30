{ ... }: {
  imports = [
    ./configuration.nix
    ./services
    ../optional-includes

    ./packages.nix
    ./nebula.nix
    ./caches.nix
  ];
}
