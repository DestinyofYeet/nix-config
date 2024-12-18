{
  pkgs,
  ...
}:{
  programs.swaylock = {
    enable = true;

    package = pkgs.swaylock-effects;
  };

  home.file = {
    ".config/swaylock/config".source = ./swaylock/config;
  };
}
