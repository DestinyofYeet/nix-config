{ home-manager, plasma-manager, inputs, ... }: {
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.sharedModules = [ 
    plasma-manager.homeManagerModules.plasma-manager 
    inputs.stylix.homeManagerModules.stylix 
  ];

  home-manager.users.ole = import ./modules;
        
  imports = [
    ./configuration.nix    
  ];
}
