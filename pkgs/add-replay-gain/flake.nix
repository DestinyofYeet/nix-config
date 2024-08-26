{
  description = "Automatically add replay gain to files";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { nixpkgs, ... }:
  let
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ]
      (system: function nixpkgs.legacyPackages.${system});
  in {
    nixosModules.default = {config, ...}:{
      options.services.add-replay-gain = {};

      config = let 
        default = pkgs.callPackage ./add-replay-gain-pkg.nix { settings = config.services.add-replay-gain};
      in {
        environment.systemPackages = [ default ];
      };
    };
    
    packages = forAllSystems (pkgs: {
      default = pkgs.callPackage ./add-replay-gain-pkg.nix {};
    }); 
  };
}
