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
      inheritParentConfig = true;

      configuration = {
        system.nixos.tags = [ "de-kde" ];
        environment.plasma6.excludePackages = with pkgs.kdePackages; [ plasma-browser-integration ];
        services.desktopManager.plasma6.enable = true;

        xdg.portal.extraPortals = lib.mkForce [
          pkgs.xdg-desktop-portal-kde
        ];

        home-manager.extraSpecialArgs.current-specialisation = "de-kde";
        home-manager.users.ole = {...}:{
          imports = [
            ./modules/default.nix
            ./modules/desktop-environments/kde
          ];
        };
      };      
    };

    "de-hyprland" = {
      inheritParentConfig = true;

      configuration = {
        system.nixos.tags = [ "de-hyprland" ];
        security.pam.services.swaylock = { };
        services.gnome.gnome-keyring.enable = true;

        programs.hyprland = {
          enable = true;
          withUWSM = true;
        };

        programs.uwsm.enable = true;
        programs.iio-hyprland.enable = true;

        xdg.portal.extraPortals = lib.mkForce [
          pkgs.xdg-desktop-portal-hyprland
        ];

        home-manager.extraSpecialArgs.current-specialisation = "de-hyprland";
        home-manager.users.ole = {...}:{
          imports = [
            ./modules/default.nix
            ./modules/desktop-environments/hyprland
            ];
        };
      };      
    };
  };


  imports = [
    ../baseline
    ./configuration.nix
  ];
}
