{ pkgs, ... }:
let  
    rebuild-system = pkgs.writeShellScriptBin "rebuild-system" ''
      set -e
      cd /home/ole/nixos
      ./build.sh
      cd - > /dev/null
    '';
in {

  programs.zsh = {
    enable = true;

    enableCompletion = true;

    shellAliases = {
      rebuild-system = "${rebuild-system}/bin/rebuild-system";
      kssh = "kitten ssh";
      icat = "kitten icat";
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
