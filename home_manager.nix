{ config, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.ole = {
    home.stateVersion = "24.05";

    programs.vim = {
      enable = true;
      extraConfig = ''
        set tabstop=4
        set number
      '';
    };
  };

  # Optionally, use home-manager.extraSpecialArgs to pass
  # arguments to home.nix
}

