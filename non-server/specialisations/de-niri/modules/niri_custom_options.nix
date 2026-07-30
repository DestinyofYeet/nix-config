{ lib, config, ... }: {
  options =
    let
      inherit (lib) mkOption types;
    in
    {
      programs.niri.custom = {
        namedWorkspaces = mkOption {
          type = types.listOf (
            types.submodule {
              options = {
                name = mkOption {
                  type = types.str;
                  description = "The name of the workspace";
                };

                keybind = mkOption {
                  type = types.str;
                  description = "The keybind to jump to the workspace";
                };

                matches = mkOption {
                  type = types.listOf types.attrs;
                  description = "The window-rule to match";
                };
              };
            }
          );
        };
      };
    };

  config =
    let
      cfg = config.programs.niri.custom;
    in
    lib.mkIf (builtins.length (cfg.namedWorkspaces) != 0) {
      programs.niri.settings = {
        workspaces = builtins.listToAttrs (
          map (workspace: {
            name = workspace.name;
            value = {
              name = workspace.name;
            };
          }) cfg.namedWorkspaces
        );

        binds = builtins.listToAttrs (
          map (workspace: {
            name = workspace.keybind;
            value = {
              action.focus-workspace = workspace.name;
            };
          }) cfg.namedWorkspaces
        );

        window-rules = map (workspace: {
          matches = workspace.matches;
          open-on-workspace = workspace.name;
        }) cfg.namedWorkspaces;
      };
    };
}
