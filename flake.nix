{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix.url = "github:danth/stylix/release-24.05";
  };

  outputs = { self, nixpkgs, home-manager, agenix, plasma-manager,  stylix, ... }@inputs: {
    nixosConfigurations.nix-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./server
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default

        ({ ... }: {
          environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
        })
      ];
    };

		nixosConfigurations.kartoffelkiste = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager plasma-manager inputs;
      };
			modules = [
				./laptop
        home-manager.nixosModules.home-manager

        agenix.nixosModules.default

				(
					{ ... }: {
						environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
					}
				)
			];
		};
  };
}
