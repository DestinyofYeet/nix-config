{ inputs, lib, }:
let
  git-secrets = builtins.fetchGit {
    url = "git@github.com:DestinyofYeet/nix-secrets.git";
    rev = "0ee6b577a3159cd252ad59a3a652dd5cedc3b7f0";
    ref = "main";
  };

  pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

  inherits = { inherit inputs pkgs lib; };
in rec {
  scripts = import ./scripts { inherit inputs pkgs lib; };

  vm = import ./mkVm { inherit inherits; };

  mkIfLaptop = config: attr:
    lib.mkIf (config.networking.hostName == "wattson") attr;

  isLaptop = config:
    (config.networking.hostName == "wattson" || config.networking.hostName
      == "kartoffelkiste");

  isMain = config: config.networking.hostName == "main";

  mkIfLaptopElse = config: attr: default:
    if (isLaptop config) then attr else default;

  mkIfMainElse = config: attr: default:
    if (config.networking.hostName == "main") then attr else default;

  update-needed-content = pkgs.writeShellScriptBin "update-needed-content" ''
    set -e

    SOURCE_DIR="$1"
    DEST_DIR="$2"

    mkdir -p "$DEST_DIR"

    ${pkgs.rsync}/bin/rsync -a --delete "$SOURCE_DIR/" "$DEST_DIR"
  '';

  update-needed-content-file =
    pkgs.writeShellScriptBin "update-needed-content-file" ''
      set -e

      SOURCE_FILE="$1"
      DEST_FILE="$2"

      mkdir -p $(dirname "$DEST_FILE")

      if [ ! -f "$DEST_FILE" ]; then
        cp "$SOURCE_FILE" "$DEST_FILE"
      fi
    '';

  gen-activation = src: dst: ''
    ${pkgs.bash}/bin/bash ${update-needed-content}/bin/update-needed-content ${src} ${dst}
  '';

  gen-activation-file = src: dst: ''
    ${pkgs.bash}/bin/bash ${update-needed-content-file}/bin/update-needed-content-file ${src} ${dst}
  '';

  settings = {
    editor = "hx";

    # screenshot-cmd = "${pkgs.hyprshot}/bin/hyprshot -m window -z -m region -o /tmp";
    screenshot-cmd = ''
      ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0)" - | ${pkgs.satty}/bin/satty -f - --early-exit --fullscreen -o /tmp/screenshot.png --copy-command ${pkgs.wl-clipboard}/bin/wl-copy'';

    nix-server = {
      secrets = import "${git-secrets}/secrets.nix" { };

      paths.data = "/mnt/data/data";
      paths.configs = "/mnt/data/configs";

      user = "apps";
      group = "apps";

      uid = "568";
      gid = "568";

      nginx-local-ssl = {
        forceSSL = true;
        useACMEHost = "wildcard.local.ole.blue";
      };
    };

    non-server = {
      background = "/etc/backgrounds/background.jpg";
      lock-screen = "/etc/backgrounds/lockscreen.jpg";
    };
  };
}
