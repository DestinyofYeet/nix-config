{ home-manager, inputs, config, ... }: {
  
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";

  home-manager.sharedModules = [ 
    inputs.plasma-manager.homeManagerModules.plasma-manager 
    inputs.stylix.homeManagerModules.stylix 
    inputs.agenix.homeManagerModules.age
    inputs.shell-aliases.homeManagerModules.default
  ];

  home-manager.users.ole = import ./modules;
        
  imports = [
    ../baseline
    ./configuration.nix
  ];
}
