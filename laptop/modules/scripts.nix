{ pkgs, ... }: {

  update-needed-content = pkgs.writeShellScriptBin "update-needed-content" ''
    set -e

    SOURCE_DIR="$1"
    DEST_DIR="$2"

    mkdir -p "$DEST_DIR"

    ${pkgs.rsync}/bin/rsync -a --delete "$SOURCE_DIR/" "$DEST_DIR"
  '';
}
