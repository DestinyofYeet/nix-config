{ pkgs, ... }: {

  programs.bash = let  
    rebuild-system = pkgs.writeShellScriptBin "rebuild-system" ''
      set -e
      cd /home/ole/nixos
      ./build.sh
      cd -
    '';
  in 
  {
    enable = true;

    shellAliases = {
      rebuild-system = "${rebuild-system}/bin/rebuild-system";
    };
  };
}
