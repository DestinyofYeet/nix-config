{ inputs, ... }:
{

  imports = [
    ../common/gnome-keyring.nix
  ];

  system.nixos.tags = [ "de-niri" ];

  security.pam.services.swaylock = { };

  security.polkit.enable = true;

  nixpkgs.overlays = [ inputs.niri-flake.overlays.niri ];

  programs.niri.enable = true;

  services.iio-niri = {
    enable = true;
  };

  home-manager.extraSpecialArgs.current-specialisation = "de-niri";
  home-manager.users.ole =
    { ... }:
    {
      imports = [
        ../../modules
        ./modules
      ];
    };
}
