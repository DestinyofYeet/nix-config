{ home-manager, plasma-manager, inputs, ... }: {
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.sharedModules = [ 
    plasma-manager.homeManagerModules.plasma-manager 
    inputs.stylix.homeManagerModules.stylix 
    inputs.agenix.homeManagerModules.age
  ];

  home-manager.users.ole = import ./modules;
        
  imports = [
    ../baseline
    ./configuration.nix
  ];
}
