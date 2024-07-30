{ home-manager, plasma-manager, ... }: {
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

  home-manager.users.ole = import ./modules;
        
  imports = [
    ./configuration.nix    
  ];
}
