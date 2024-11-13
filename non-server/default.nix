{ inputs, ... }: {

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = {
      inherit inputs;
    };

    sharedModules = [ 
      inputs.plasma-manager.homeManagerModules.plasma-manager 
      inputs.stylix.homeManagerModules.stylix 
      inputs.agenix.homeManagerModules.age
      inputs.shell-aliases.homeManagerModules.default
    ];

    users = {
      ole = import ./modules;
    };
  };  
       
  imports = [
    ../baseline
    ./configuration.nix
  ];
}
