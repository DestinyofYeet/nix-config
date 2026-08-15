{ inputs, ... }:
{

  imports = [
    ../common/gnome-keyring.nix
  ];

  system.nixos.tags = [ "de-niri" ];

  security.polkit.enable = true;

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
