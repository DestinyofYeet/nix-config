{ pkgs, lib, config, osConfig, ... }:
let
  make-option = file-names:
    (lib.genAttrs file-names
      (name: lib.mkOption { type = lib.types.package; }));

  make-config = file-names:
    (lib.genAttrs file-names
      (name: pkgs.writeText "${name}.nu" (builtins.readFile ./${name}.nu)));

  make-extra-conf = file-names:
    lib.strings.concatMapStrings (name: ''
      source ${config.nuScripts.${name}}
    '') file-names;

  scripts = [ "deploy-node" "mount-navidrome" "commands" "oth-mensa" ]
    ++ (lib.optionals (lib.custom.isLaptop osConfig) [ "wattson" ]);

in {
  options.nuScripts = make-option scripts;

  config.nuScripts = make-config scripts;

  config.programs.nushell.extraConfig = make-extra-conf scripts;
}
