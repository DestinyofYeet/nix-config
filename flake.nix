{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    stylix = {
      # url = "github:danth/stylix/ed91a20c84a80a525780dcb5ea3387dddf6cd2de";
      url = "github:danth/stylix";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    add-replay-gain = {
      url = "github:DestinyofYeet/add_replay_gain";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    clean-unused-files = {
      url = "github:DestinyofYeet/clean_unused_files";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    networkNamespaces = {
      # url = "path:///home/ole/nixos/customLibs/networkNamespaces";
      url = "github:DestinyofYeet/namespaces.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:ch4og/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # strichliste = {
    #   url = "github:DestinyofYeet/nix-strichliste";
    #   # url = "path:///home/ole/github/nix-strichliste";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { self, nixpkgs, home-manager, agenix, plasma-manager, stylix, nur, ... }@inputs: let 
    inherit self;
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
      (
        {...}:{
          environment.systemPackages = [ inputs.zen-browser.packages.x86_64-linux.specific ];
        }
      )
    ] ++ baseline-modules;
  in
  {
    nixpkgs.config.rocmSupport = true;
    
    nixosConfigurations.nix-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit home-manager inputs; };
      modules = [
        inputs.add-replay-gain.nixosModules.add-replay-gain
        inputs.clean-unused-files.nixosModules.clean-unused-files
        # inputs.strichliste.nixosModules.strichliste
        inputs.networkNamespaces.nixosModules.networkNamespaces
        ./server
      ] ++ baseline-modules;
    };

    deploy.nodes.nix-server = {
      hostname = "nix-server.infra.wg";
      profiles.system = {
        sshUser = "root";
        user = "root";
        path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nix-server;
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

    nixosConfigurations.kartoffelkiste = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager inputs;
      };
      modules = [
        ./non-server/hardware/kartoffelkiste.nix
				./non-server
			] ++ laptop-modules;
		};

    nixosConfigurations.wattson = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager inputs;
      };
      modules = [
        ./non-server/hardware/wattson.nix
        ./non-server/extra-configurations/wattson
				./non-server
        # inputs.strichliste.nixosModules.strichliste
			] ++ laptop-modules;
		};

    nixosConfigurations.main = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit home-manager inputs;
      };
      modules = [
        ./non-server/hardware/main.nix
        ./non-server/extra-configurations/main
        ./non-server
      ] ++ laptop-modules;
    };

    hydraJobs = let 

      makeConfigurations = configurations:
        builtins.listToAttrs (map (configuration: { name = configuration; value = self.nixosConfigurations.${configuration}.config.system.build.toplevel; }) configurations);

    in {
      system-builds = makeConfigurations [
        "main"
        "wattson"
#         "nix-server" # doesn't work, because to fetch the secrets repository, it needs access to /root/.ssh/config, which it doesn't do
      ];
    };
  };
}
