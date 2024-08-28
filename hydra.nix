{ inputs, outputs }:
let
  inherit (inputs.nixpkgs.lib) filterAttrs mapAttrs elem;

  notBroken = pkg: !(pkg.meta.broken or false);
  isDistributable = pkg: (pkg.meta.license or { redistributable = true; }).redistributable;
  hasPlatform = sys: pkg: elem sys (pkg.meta.platforms or [ ]);
  filterValidPkgs = sys: pkgs: filterAttrs (_: pkg: hasPlatform sys pkg && notBroken pkg && isDistributable pkg) pkgs;

  excludedHost = "nix-server"; # Name of the host to exclude
  
  getCfg = name: cfg: if name == excludedHost then null else cfg.config.system.build.toplevel;
  
  filterNulls = attrs: filterAttrs (_: v: v != null) attrs; 
in {
  pkgs = mapAttrs filterValidPkgs outputs.packages;
  hosts = filterNulls (mapAttrs getCfg outputs.nixosConfigurations);
}
