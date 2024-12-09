{
  lib,
  ...
}:
let
  mkWorkSpaceBind = number : workspace : 
    "$mainMod, ${toString number}, workspace, ${toString workspace}";

  mkMoveWorkSpaceBind = number : workspace :
    "$mainMod SHIFT, ${toString number}, movetoworkspace, ${toString workspace}";

  mkGenericWorkSpaceBinds = list : 
    (lib.concatLists (map (number: [ (mkWorkSpaceBind number number) (mkMoveWorkSpaceBind number number) ]) list));
in {
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      "$mainMod" = "SUPER";
      "$fileManager" = "dolphin";
      "$terminal" = "kitty";
    
      input = {
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
        };

        tablet = {
          output = "current";
        };

        kb_layout = "de";
      };

      bind = [
        "$mainMod SHIFT, esc, exit"
        "$mainMod E, exec, $fileManager"

        (mkWorkSpaceBind 0 10)
        (mkMoveWorkSpaceBind 0 10)
      ]
      ++ (mkGenericWorkSpaceBinds [ 1 2 3 4 5 6 7 8 9 ])
      ;
    };
  };
}
