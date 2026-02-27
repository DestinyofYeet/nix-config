{ lib, pkgs, ... }:
{
  programs.nushell = {
    configFile.text = ''
      def screens-mirror [] {
        ${lib.getExe' pkgs.wl-mirror "wl-mirror"} (niri msg --json focused-output | ${lib.getExe pkgs.jq} -r .name) 
      }
    '';
  };
}
