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

    add-replay-gain = {
      url = "github:DestinyofYeet/add_replay_gain";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    clean-unused-files = {
      url = "github:DestinyofYeet/clean_unused_files";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, plasma-manager, stylix, nur, ... }@inputs: let 
    inherit (self) outputs;
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
        inputs.add-replay-gain.nixosModules.add-replay-gain
        inputs.clean-unused-files.nixosModules.clean-unused-files
        ./server
      ] ++ baseline-modules;
    };

    nixosConfigurations.kartoffelkiste = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager plasma-manager inputs;
      };
      modules = [
        ./non-server/hardware/kartoffelkiste.nix
				./non-server
			] ++ laptop-modules;
		};

    nixosConfigurations.wattson = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager plasma-manager inputs;
      };
      modules = [
        ./non-server/hardware/wattson.nix
        ./non-server/extra-configurations/wattson
				./non-server
			] ++ laptop-modules;
		};

    nixosConfigurations.main = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager plasma-manager inputs;
      };
      modules = [
        ./non-server/hardware/main.nix
        ./non-server/extra-configurations/main
        ./non-server
      ] ++ laptop-modules;
    };

    #hydraJobs = {
    #  wattson = self.nixosConfigurations.wattson.config.system.build.toplevel;
    #  main = self.nixosConfigurations.main.config.system.build.toplevel;
    #};

    hydraJobs = 

    let 
      blacklist = [
        "nixos-help"
        "steam-run"
        "steam"
      ];

      isNotBlacklisted = blacklist: pkg: !(builtins.elem pkg.name blacklist);

      mergePackages = configurations: blacklisted-pkgs :
        builtins.filter (isNotBlacklisted blacklisted-pkgs) (builtins.concatLists (map (configuration: self.nixosConfigurations.${configuration}.config.environment.systemPackages) configurations));
      
      makePackages = packages:
        builtins.listToAttrs (map (package: {name = package.name; value = package; }) packages);

    in {
      packages.x86_64-linux = makePackages (
        mergePackages [
          "wattson"
          "main"
          "nix-server"
        ] blacklist
      );
    };
  };
}
