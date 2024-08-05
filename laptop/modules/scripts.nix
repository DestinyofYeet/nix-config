{ config, pkgs, ... }: 
let
  scripts-dir = "${config.home.homeDirectory}/scripts";
in {

  home.file = {
    "${scripts-dir}/update-needed-content.sh" = {
      text = ''
        #!${pkgs.bash}/bin/bash

        set -e

        SOURCE_DIR="$1"
        DEST_DIR="$2"

        mkdir -p "$DEST_DIR"

        ${pkgs.rsync}/bin/rsync -a --delete "$SOURCE_DIR/" "$DEST_DIR"
      '';    
    };
  };
}
