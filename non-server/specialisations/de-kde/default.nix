{
  pkgs,
  lib,
  ...
}:{
  
  system.nixos.tags = [ "de-kde" ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [ plasma-browser-integration ];
  services.desktopManager.plasma6.enable = true;

  xdg.portal.extraPortals = lib.mkForce [
    pkgs.xdg-desktop-portal-kde
  ];

  programs.dconf.enable = true;

  
  services.displayManager.sddm = {
    enable = true;
    theme = "catppuccin-mocha";
    # theme = "${sddm-theme}";

    wayland.enable = true;
  };

  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      #font  = "Noto Sans";
      #fontSize = "9";
      background = "${../../../images/forest.png}";
      loginBackground = true;
    })
  ];

  home-manager.extraSpecialArgs.current-specialisation = "de-kde";
  home-manager.users.ole = {...}:{
    imports = [
      ../../modules
      ./modules
    ];
  };
}
