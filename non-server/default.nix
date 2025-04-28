{ inputs, stable-pkgs, pkgs, lib, custom, secretStore, flake, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";

    extraSpecialArgs = { inherit inputs stable-pkgs custom secretStore flake; };

    sharedModules = [
      inputs.plasma-manager.homeManagerModules.plasma-manager
      inputs.stylix.homeManagerModules.stylix
      inputs.agenix.homeManagerModules.age
      inputs.shell-aliases.homeManagerModules.default
      inputs.nixvim.homeManagerModules.nixvim
    ];
  };

  specialisation = {
    "de-kde" = { configuration = import ./specialisations/de-kde; };

    "de-hyprland" = { configuration = import ./specialisations/de-hyprland; };
  };

  imports = [ ../baseline ./configuration.nix ];
}
