{ home-manager, inputs, ... }: {
  imports = [
    ../../baseline
    ./configuration.nix
    ./home_manager.nix
  ];
}
