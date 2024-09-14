{ pkgs, ... }: let
  extra-conf = pkgs.writeText "git-extra.conf" ''
    [safe] 
      directory = *;
  '';
in {
  programs.git = {
    includes = [
      { path = "${extra-conf}"; }
    ];
  };
}
