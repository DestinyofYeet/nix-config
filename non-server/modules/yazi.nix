{ inputs, ... }: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    shellWrapperName = "yz";

    flavors = let ghFlavors = inputs.yazi-flavors;
    in { catppuccin-mocha = "${ghFlavors}/catppuccin-mocha.yazi/"; };

    theme = { flavor = { dark = "catppuccin-mocha"; }; };

    settings = { mgr = { show_hidden = true; }; };
  };
}
