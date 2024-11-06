{
  pkgs,
  lib,
  ...
}:let 
  make-option = file-names:  (lib.genAttrs file-names (name: lib.mkOption { type = lib.types.package; }));

  make-config = file-names: (lib.genAttrs file-names (name: pkgs.writeText "${name}.nu" (builtins.readFile ./${name}.nu)));

  scripts = [
    "deploy-node"
  ];
  
in {
  options.nuScripts = make-option scripts;

  config.nuScripts = make-config scripts;
}
