{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.sharedModules = [ inputs.agenix.homeManagerModules.age ];
  home-manager.users.ole = {
    home.stateVersion = "24.05";

    imports = [
      ../../baseline/modules
      ./hm-modules
    ];
  };

  # Optionally, use home-manager.extraSpecialArgs to pass
  # arguments to home.nix
}
