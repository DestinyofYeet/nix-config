{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix.url = "github:danth/stylix";

    nur.url = "github:nix-community/NUR";
  };

  outputs = { self, nixpkgs, home-manager, agenix, plasma-manager, stylix, nur, ... }@inputs: let 
    baseline-modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default

        ({ ... }: {
          environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
        })
      ];

    laptop-modules = [ 
      { nixpkgs.overlays = [ nur.overlay ]; }

      nur.nixosModules.nur
    ] ++ baseline-modules;
  in
  {
    nixosConfigurations.nix-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit home-manager inputs; };
      modules = [
        ./server
      ] ++ baseline-modules;
    };

    nixosConfigurations.kartoffelkiste = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager plasma-manager inputs;
      };
      modules = [
        ./laptop/hardware/kartoffelkiste.nix
				./laptop
			] ++ laptop-modules;
		};

    nixosConfigurations.wattson = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager plasma-manager inputs;
      };
      modules = [
        ./laptop/hardware/wattson.nix
				./laptop
			] ++ laptop-modules;
		};
  };
}
