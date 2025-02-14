{
  pkgs,
  config,
  osConfig,
  lib,
  ...
}: let
  rebuild-system = pkgs.writeShellScriptBin "rebuild-system" ''
    set -e

    cd /home/ole/nixos
    ./build.sh $@
    cd - > /dev/null
  '';

  deploy-node = pkgs.writeShellScriptBin "deploy-node" ''
    set -e
    cd /home/ole/nixos
    deploy -s ".#$1" ''${@:2}
    cd - > /dev/null
  '';

  stylix-color-picker = pkgs.writeShellScriptBin "stylix-color-picker" ''
    set -e

    color_picked=$(ls ${pkgs.base16-schemes}/share/themes | ${pkgs.fzf}/bin/fzf)

    if [ -z $color_picked ]; then
      echo "No color selected!"
      exit 1
    fi

    echo $color_picked > /home/ole/nixos/laptop/modules/current_color.txt

    echo "Picked color $color_picked"

    read -p "Update the system? (y/n)" yes_no

    case $yes_no in
      y ) echo Updating...;;
      n ) exit 0;;
      * ) exit 1;;
    esac

    ${rebuild-system}/bin/rebuild-system
  '';
in {
  programs.zsh = {
    enable = true;

    enableCompletion = true;

    shellAliases = {
      # rebuild-system = "${rebuild-system}/bin/rebuild-system";
      deploy-node = "${deploy-node}/bin/deploy-node";
      stylix-color-picker = "${stylix-color-picker}/bin/stylix-color-picker";

      setup-env = "${osConfig.customScripts.setup-env}";

      kssh = "kitten ssh";
      icat = "kitten icat";
    };

    sessionVariables = {
      EDITOR = "hx";
    };

    oh-my-zsh = {
      enable = true;

      theme = "gnzh"; # "frisk", "fishy", "gnzh"

      plugins = [
        "zoxide"
        "zsh-interactive-cd"
      ];

      extraConfig = ''
        ZOXIDE_CMD_OVERRIDE=cd
      '';
    };

    syntaxHighlighting.enable = true;
  };
}
