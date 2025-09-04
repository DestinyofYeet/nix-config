{ inputs, pkgs, ... }: {
  programs.anyrun = rec {
    enable = true;

    package = inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins;

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

      # plugins = with inputs.anyrun.packages.${pkgs.system}; [
      #   applications
      #   shell
      #   rink
      #   stdin
      #   symbols
      #   randr
      # ];

      plugins = [
        "${package}/lib/libapplications.so"
        "${package}/lib/libshell.so"
        "${package}/lib/libnix_run.so"
        "${package}/lib/librink.so"
      ];
    };

    extraConfigFiles = {
      "symbols.ron".text = ''
        Config(
          prefix: ":sym",
        )
      '';
    };
  };
}
