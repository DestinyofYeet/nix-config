{
  inputs,
  pkgs,
  ...
}:{
  programs.anyrun = {
    enable = true;

    # package = inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins;

    config = {
      x = { fraction = 0.5; };
      y = { fraction = 0.3; };
      width = { fraction = 0.3; };
      hideIcons = false;
      ignoreExclusiveZones = false;
      layer = "overlay";
      hidePluginInfo = false;
      closeOnClick = false;
      showResultsImmediately = false;
      maxEntries = null;

      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        applications
        shell
        rink
        stdin
        symbols
        randr
      ];
    };
  };
}
