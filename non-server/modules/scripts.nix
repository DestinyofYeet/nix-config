{ pkgs, config, ... }: {

  update-needed-content = pkgs.writeShellScriptBin "update-needed-content" ''
    set -e

    SOURCE_DIR="$1"
    DEST_DIR="$2"

    mkdir -p "$DEST_DIR"

    ${pkgs.rsync}/bin/rsync -a --delete "$SOURCE_DIR/" "$DEST_DIR"
  '';

  update-needed-content-file = pkgs.writeShellScriptBin "update-needed-content-file" ''
    set -e

    SOURCE_FILE="$1"
    DEST_FILE="$2"

    mkdir -p $(dirname "$DEST_FILE")

    if [ ! -f "$DEST_FILE" ]; then
      cp "$SOURCE_FILE" "$DEST_FILE"
    fi
  '';

  generate-email-alias = pkgs.writers.writePython3Bin "generate-email-alias" {
    flakeIgnore = [ "W291" "E305" "E501" "E111" "E302" ];
  } ''
    import random
    import string

    def generate_alias(length: int, chars_to_use: list[str]) -> str:
      password = ""
      for _ in range(length):
          password += random.choice(random.choice(chars_to_use))

      return password


    def main():
      alias = generate_alias(20, [string.ascii_letters + string.digits])

      print(f"Alias: {alias}@uwuwhatsthis.de")  # if stalwarts breaks again, use config.customSettings.stable-pkgs.stalwart-mail

    if __name__ == '__main__':
      main()
  '';
}
