{ pkgs, ... }: {
  programs.bash = {
    enable = true;

    shellAliases = {
      rebuild-system = pkgs.writeShellScript "rebuild-system" ''
        cd /home/ole/nixos
        ./build
        cd -
       ''; 
    };
  };
}
