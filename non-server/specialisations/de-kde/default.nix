{ pkgs, lib, ... }: {

  system.nixos.tags = [ "de-kde" ];
  environment.plasma6.excludePackages = with pkgs.kdePackages;
    [ plasma-browser-integration ];
  services.desktopManager.plasma6.enable = true;

  programs.dconf.enable = true;

  home-manager.extraSpecialArgs = { current-specialisation = "de-kde"; };
  home-manager.users.ole = { ... }: { imports = [ ../../modules ./modules ]; };
}
