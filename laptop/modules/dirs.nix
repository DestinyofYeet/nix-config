{config, ... }: rec {
  home = {
    path = "${config.home.homeDirectory}";
    scripts = {
      path = "${home.path}/scripts";
    };

    icons = {
      path = "${home.path}/.icons";
    };

    local = {
      path = "${home.path}/.local";

      share = {
        path = "${home.local.path}/share";

        icons = {
          path = "${home.local.share.path}/icons";
        };

        aurorae = {
          path = "${home.local.share.path}/aurorae";

          themes = {
            path = "${home.local.share.aurorae.path}/themes";
          };
        };

        plasma = {
          path = "${home.local.share.path}/plasma";

          desktoptheme = {
            path = "${home.local.share.plasma.path}/desktoptheme";
          };

          look-and-feel = {
            path = "${home.local.share.plasma.path}/look-and-feel";
          };
        };
      };
    };
  };
}
