{ home-manager, inputs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.sharedModules = [
    inputs.agenix.homeManagerModules.age
  ];
  home-manager.users.ole = import ./hm-modules;

  imports = [
    ../baseline
    ./configuration.nix
    ./home_manager.nix
  ];
}
