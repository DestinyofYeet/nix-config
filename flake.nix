{
  # nixConfig = { allow-import-from-derivation = false; }; # stylix base16.nix has IFD

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    stable-nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    old-nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

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
      # inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    strichliste = {
      url = "git+https://code.ole.blue/ole/strichliste.nix";
      # url = "path:///home/ole/github/strichliste.nix";
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
      url = "gitlab:simple-nixos-mailserver/nixos-mailserver/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # mdpls-nix = {
    #   url = "github:DestinyofYeet/mdpls.nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helix = {
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lemonake = {
      url = "github:PassiveLemon/lemonake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    waybar-taskwarrior = {
      url = "git+https://code.ole.blue/ole/waybar-taskwarrior.rs";
      # url = "path:///home/ole/github/waybar-taskwarrior.rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    setup-env-rs = {
      url = "git+https://code.ole.blue/ole/setup-env.rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # prost = {
    #   url = "github:haennes/prost";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nuscht-search = {
      url = "github:NuschtOS/search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprgrass = {
    #   url = "github:horriblename/hyprgrass";
    #   inputs = {
    #     nixpkgs.follows = "nixpkgs";
    #     hyprland.follows = "hyprland";
    #   };
    # };

    auto-add-torrents = {
      url = "git+https://code.ole.blue/ole/auto-add-torrents-python";
      # url = "path:///home/ole/github/auto-add-torrents-python";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi-flavors = {
      url = "github:yazi-rs/flavors";
      flake = false;
    };

    microvm-nix = {
      url = "github:astro/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware = { url = "github:NixOS/nixos-hardware"; };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    nix-joint-venture = {
      url = "github:nix-joint-venture/nix-joint-venture";
      # url = "github:DestinyofYeet/nix-joint-venture";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nc4nix = {
      url = "github:helsinki-systems/nc4nix";
      flake = false;
    };

    argon40-nix = {
      url = "github:guusvanmeerveld/argon40-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    nix-monitored.url = "github:ners/nix-monitored";

    squid-api = {
      url = "git+https://code.ole.blue/ole/squid-api";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    strichliste-rs = {
      url = "github:DestinyofYeet/strichliste";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    determinate-nix = {
      url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    };

    anyrun-custom-command = {
      # url = "git+file:///home/ole/github/rest/anyrun-custom-command";
      url = "github:DestinyofYeet/anyrun-custom-command";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable"; # got nuked

    # fladder-nix.url = "git+file:///home/ole/github/rest/fladder.nix";
    fladder-nix.url = "github:DestinyofYeet/fladder.nix";
    tiddl-nix.url = "github:DestinyofYeet/tiddl.nix";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url =
        "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    authentik-nix.url = "github:nix-community/authentik-nix";
  };

  outputs = { self, nixpkgs, home-manager, agenix, plasma-manager, stylix, nur
    , ... }@inputs:
    let
      inherit self;

      lib = nixpkgs.lib.extend (self: super: {
        custom = import ./lib {
          inherit inputs;
          lib = self;
        };
      });

      custom = import ./custom { inherit lib; };

      baseline-modules = [
        ./options/beszel
        home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        inputs.nix-topology.nixosModules.default
        # inputs.prost.nixosModules.default
        inputs.strichliste.nixosModules.strichliste
        ({ ... }: {
          environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
        })

        inputs.microvm-nix.nixosModules.host

        inputs.lix-module.nixosModules.default
      ];

      non-server-modules = [
        {
          nixpkgs.overlays = [
            nur.overlays.default
            inputs.helix.overlays.default
            inputs.yazi.overlays.default

            # no-worky
            # inputs.nix-monitored.overlays.default
            # (self: super: {
            #   nix-direnv =
            #     super.nix-direnv.override { nix = super.nix-monitored; };
            # })
          ];
        }

        inputs.nix-flatpak.nixosModules.nix-flatpak

        nur.modules.nixos.default
        inputs.lanzaboote.nixosModules.lanzaboote
        ({ ... }: {
          environment.systemPackages = [
            inputs.zen-browser.packages.x86_64-linux.specific
            inputs.nix-fast-build.packages.x86_64-linux.default
            inputs.setup-env-rs.packages.x86_64-linux.default
          ];
        })
      ] ++ baseline-modules;

      stable-pkgs = import inputs.stable-nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      old-pkgs = import inputs.old-nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      secretStore = import ./secretStore { };

      defaultSpecialArgs = {
        inherit inputs stable-pkgs old-pkgs lib custom home-manager secretStore;
        flake = self;
      };

      makeConfigurations = configurations:
        builtins.listToAttrs (map (configuration: {
          name = configuration;
          value =
            self.nixosConfigurations.${configuration}.config.system.build.toplevel;
        }) configurations);

      mkHost = (import ./options/mkHost { inherit nixpkgs; }).mkHost;
    in {
      # pfusch, used for micro-vms
      inherit defaultSpecialArgs;
      nixpkgs.config.rocmSupport = true;

      # This is highly advised, and will prevent many possible mistakes
      checks = makeConfigurations [ "main" "wattson" ] // builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        inputs.deploy-rs.lib;

      nixosConfigurations = {
        nix-server = mkHost {

          system = "x86_64-linux";
          specialArgs = defaultSpecialArgs;
          modules = [
            inputs.add-replay-gain.nixosModules.add-replay-gain
            inputs.clean-unused-files.nixosModules.clean-unused-files
            # inputs.strichliste.nixosModules.strichliste
            inputs.networkNamespaces.nixosModules.networkNamespaces
            inputs.prometheus-qbit.nixosModules.default
            inputs.auto-add-torrents.nixosModules.default
            inputs.authentik-nix.nixosModules.default
            ./hosts/nix-server
          ] ++ baseline-modules;

          capabilities = { headless.enable = true; };
        };

        kartoffelkiste = mkHost {
          system = "x86_64-linux";
          specialArgs = defaultSpecialArgs;
          modules = [
            ./non-server/hardware/kartoffelkiste.nix
            ./non-server/extra-configurations/kartoffelkiste
            ./non-server
          ] ++ non-server-modules;

          capabilities = {
            monitor.enable = true;
            battery.enable = true;
          };
        };

        wattson = mkHost {
          system = "x86_64-linux";
          specialArgs = defaultSpecialArgs;
          modules = [
            ./non-server/hardware/wattson.nix
            ./non-server/extra-configurations/wattson
            ./non-server
          ] ++ non-server-modules;

          capabilities = {
            touch.enable = true;
            battery.enable = true;
            monitor.enable = true;
            bluetooth.enable = true;
            wifi.enable = true;
          };
        };

        main = mkHost {
          system = "x86_64-linux";
          specialArgs = defaultSpecialArgs;
          modules = [
            ./non-server/hardware/main.nix
            ./non-server/extra-configurations/main
            ./non-server
          ] ++ non-server-modules;

          capabilities = { monitor.enable = true; };

        };

        teapot = mkHost rec {

          system = "x86_64-linux";
          modules = [
            inputs.simple-nixos-mailserver.nixosModule
            inputs.nix-minecraft.nixosModules.minecraft-servers
            inputs.strichliste-rs.nixosModules.${system}.default
            { nixpkgs.overlays = [ inputs.nix-minecraft.overlay ]; }
            inputs.authentik-nix.nixosModules.default

            ./hosts/teapot
          ] ++ baseline-modules;

          specialArgs = defaultSpecialArgs;

          capabilities = { headless.enable = true; };
        };

        bonk = mkHost {

          system = "x86_64-linux";
          modules = [ ./hosts/bonk ] ++ baseline-modules;

          specialArgs = defaultSpecialArgs;
          capabilities = { headless.enable = true; };
        };

        nixie = mkHost {

          system = "aarch64-linux";
          modules = [
            inputs.argon40-nix.nixosModules.default
            inputs.hardware.nixosModules.raspberry-pi-4

            ./hosts/nixie
          ] ++ baseline-modules;
          specialArgs = defaultSpecialArgs;

          capabilities = { headless.enable = true; };
        };

        audioPi = mkHost {
          system = "aarch64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
            inputs.hardware.nixosModules.raspberry-pi-4

            ./hosts/audioPi
          ];

          capabilities = {
            headless.enable = true;
            customNixInterpreter.enable = false;
            agenix.enable = false;
            nebulaVpn.enable = false;
          };

          specialArgs = defaultSpecialArgs;
        };
      };

      images.audioPi =
        self.nixosConfigurations.audioPi.config.system.build.sdImage;

      deploy.nodes = {
        nix-server = {
          hostname = "nix-server";
          profiles.system = {
            sshUser = "root";
            # user = "root";
            # interactiveSudo = true;
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.nix-server;
          };
        };

        teapot = {
          hostname = "teapot";
          profiles.system = {
            sshUser = "root";
            # user = "root";
            # interactiveSudo = true;
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.teapot;
          };
        };

        bonk = {
          hostname = "bonk";
          profiles.system = {
            sshUser = "root";

            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.bonk;
          };
        };

        nixie = {
          hostname = "nixie";
          profiles.system = {
            sshUser = "root";
            path = inputs.deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.nixie;
          };
        };
      };

      topology.x86_64-linux = import inputs.nix-topology {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ inputs.nix-topology.overlays.default ];
        };

        modules = [{ nixosConfigurations = self.nixosConfigurations; }];
      };

      hydraJobs.system-builds = makeConfigurations [
        "main"
        "wattson"
        # "nix-server" # doesn't work, because to fetch the secrets repository, it needs access to /root/.ssh/config, which it doesn't do
      ];

      formatter.x86_64-linux =
        nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;

      colmena = let
        no-build-confs = [ "main" "wattson" "kartoffelkiste" ];
        configurations =
          lib.filterAttrs (name: value: !(lib.elem name no-build-confs))
          self.nixosConfigurations;

        build-host = name: settingsAttr:
          {
            imports = configurations.${name}._module.args.modules;
          } // settingsAttr;
      in {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };

          specialArgs = defaultSpecialArgs;

          nodeNixpkgs =
            builtins.mapAttrs (name: value: value.pkgs) configurations;
          nodeSpecialArgs =
            builtins.mapAttrs (name: value: value._module.specialArgs)
            configurations;
        };

        teapot = build-host "teapot" {
          deployment = {
            targetHost = "teapot";
            targetUser = "root";
            buildOnTarget = true;
          };
        };

        nix-server = build-host "nix-server" {
          deployment = {
            targetHost = "nix-server";
            targetUser = "root";
            buildOnTarget = true;
          };
        };

        bonk = build-host "bonk" {
          deployment = {
            targetHost = "bonk";
            targetUser = "root";
            buildOnTarget = true;
          };
        };
      };
    };
}
