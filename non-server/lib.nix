{
  pkgs,
  ...
}:{

  nixpkgs.overlays = [
    (
      prev: final: {
        lib = prev.lib // {
          update-needed-content-file = pkgs.writeShellScriptBin "update-needed-content-file" ''
            set -e

            SOURCE_FILE="$1"
            DEST_FILE="$2"

            mkdir -p $(dirname "$DEST_FILE")

            if [ ! -f "$DEST_FILE" ]; then
              cp "$SOURCE_FILE" "$DEST_FILE"
            fi
          '';
        };
      }
    )
  ];
}
