{ inputs, stable-pkgs, pkgs, lib, ... }:
{

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = { inherit inputs stable-pkgs; };

    sharedModules = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
      inputs.stylix.homeManagerModules.stylix
      inputs.agenix.homeManagerModules.age
      inputs.shell-aliases.homeManagerModules.default
    ];
  };

  
  specialisation = {
    "de-kde" = {
      configuration = import ./specialisations/de-kde;
    };

    "de-hyprland" = {
      configuration = import ./specialisations/de-hyprland;
    };
  };


  imports = [
    ../baseline
    ./configuration.nix
  ];
}
