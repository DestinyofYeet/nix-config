{ lib, config, ...}:
let
  extra-config-path = builtins.toPath "./${config.networking.hostName}";
in {
  imports = lib.mkIf (builtins.pathExists extra-config-path) [
    extra-config-path
  ]
}
