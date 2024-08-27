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
    import argparse
    import os

    def generate_alias(length: int, chars_to_use: list[str]) -> str:
      password = ""
      for _ in range(length):
          password += random.choice(random.choice(chars_to_use))

      return password


    def main():
      parser = argparse.ArgumentParser(description="Creates a new permanent email alias")

      parser.add_argument("--random", action="store_true", dest="random", help="Generates a new alias to use")
      parser.add_argument("given_alias", nargs="?", help="Uses the given alias to use")

      parsed = parser.parse_args()

      alias = parsed.given_alias

      if parsed.random:
          alias = generate_alias(20, [string.ascii_letters + string.digits])

      if alias is None:
          parser.print_help()
          exit(1)

      with open("${config.age.secrets.stalwart-ole-pw.path}") as f:
        password = f.read().removesuffix("\n")

      print(f"Alias: {alias}@uwuwhatsthis.de")    
      os.system(f"${pkgs.stalwart-mail}/bin/stalwart-cli -u https://mx.uwuwhatsthis.de -c 'ole:{password}' account add-email ole {alias}@uwuwhatsthis.de")

    if __name__ == '__main__':
      main()
  '';
}
