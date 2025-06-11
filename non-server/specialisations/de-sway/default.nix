{ ... }: {

  system.nixos.tags = [ "de-sway" ];

  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;

  security.pam.services.swaylock = { };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  home-manager.extraSpecialArgs.current-specialisation = "de-sway";
  home-manager.users.ole = { ... }: { imports = [ ../../modules ./modules ]; };
}
