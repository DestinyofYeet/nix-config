{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    stable-nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

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
      # url = "path:///home/ole/github/namespaces.nix";
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

    auto-add-torrents = {
      # url = "path:///drives/programming-Stuff/python/auto-add-torrents-clean";
      url = "github:DestinyofYeet/auto-add-torrents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prometheus-qbit = {
      url = "github:DestinyofYeet/prometheus-qbitorrent.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-topology = {
      url = "github:oddlama/nix-topology";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    shell-aliases = {
      # url = "path:///home/ole/github/shell-aliases.nix";
      url = "github:DestinyofYeet/shell-aliases.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prpr-muttkalendar = {
      url = "github:DestinyofYeet/Muttkalendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-fast-build = {
      url = "github:Mic92/nix-fast-build";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    simple-nixos-mailserver = {
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mdpls-nix = {
      url = "github:DestinyofYeet/mdpls.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, agenix, plasma-manager, stylix, nur, ... }@inputs: let 
    inherit self;
    baseline-modules = [
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        inputs.nix-topology.nixosModules.default

        ({ ... }: {
          environment.systemPackages = [ 
            agenix.packages.x86_64-linux.default 
          ];
        })
      ];

    non-server-modules = [ 
      { 
        nixpkgs.overlays = [ 
          nur.overlay
        ]; 
      }

      nur.nixosModules.nur

      (
        {...}:{
          environment.systemPackages = [ 
            inputs.zen-browser.packages.x86_64-linux.specific 
            inputs.nix-fast-build.packages.x86_64-linux.default
          ];
        }
      )
    ] ++ baseline-modules;

    stable-pkgs = import inputs.stable-nixpkgs { system = "x86_64-linux"; config.allowUnfree = true; };

    defaultSpecialArgs = {
      inherit inputs stable-pkgs;
    };

    
    makeConfigurations = configurations:
      builtins.listToAttrs (map (configuration: { name = configuration; value = self.nixosConfigurations.${configuration}.config.system.build.toplevel; }) configurations);
  in
  {
    nixpkgs.config.rocmSupport = true;
    
    nixosConfigurations.nix-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit home-manager inputs stable-pkgs; };
      modules = [
        inputs.add-replay-gain.nixosModules.add-replay-gain
        inputs.clean-unused-files.nixosModules.clean-unused-files
        # inputs.strichliste.nixosModules.strichliste
        inputs.networkNamespaces.nixosModules.networkNamespaces
        inputs.auto-add-torrents.nixosModules.auto-add-torrents
        inputs.prometheus-qbit.nixosModules.default
        ./server/nix-server
      ] ++ baseline-modules;
    };

    deploy.nodes = {
      nix-server = {
        hostname = "nix-server.infra.wg";
        profiles.system = {
          sshUser = "ole";
          user = "root";
          interactiveSudo = true;
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.nix-server;
        };
      };

      teapot = {
        hostname = "teapot";
        profiles.system = {
          sshUser = "ole";
          user = "root";
          interactiveSudo = true;
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.teapot;
        };
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = makeConfigurations [ "main" "wattson" ] // builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;

    nixosConfigurations.kartoffelkiste = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = defaultSpecialArgs;
      modules = [
        ./non-server/hardware/kartoffelkiste.nix
				./non-server
			] ++ non-server-modules;
		};

    nixosConfigurations.wattson = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = defaultSpecialArgs;
      modules = [
        ./non-server/hardware/wattson.nix
        ./non-server/extra-configurations/wattson
				./non-server
        # inputs.strichliste.nixosModules.strichliste
			] ++ non-server-modules;
		};

    nixosConfigurations.main = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = defaultSpecialArgs;
      modules = [
        ./non-server/hardware/main.nix
        ./non-server/extra-configurations/main
        ./non-server
      ] ++ non-server-modules;
    };

    nixosConfigurations.teapot = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        inputs.simple-nixos-mailserver.nixosModule
      
        ./server/teapot
      ] ++ baseline-modules;

      specialArgs = defaultSpecialArgs;
    };

    topology.x86_64-linux = import inputs.nix-topology {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ inputs.nix-topology.overlays.default ];
      };

      modules = [
        { nixosConfigurations = self.nixosConfigurations; }
      ];
    };

    hydraJobs.system-builds =  makeConfigurations [
      "main"
      "wattson"
      "teapot"
      # "nix-server" # doesn't work, because to fetch the secrets repository, it needs access to /root/.ssh/config, which it doesn't do
    ];
  };

}
