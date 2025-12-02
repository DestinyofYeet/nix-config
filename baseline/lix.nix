{ pkgs, ... }: {

  nix = {
    package = builtins.trace "Setting nix.package to lix"
      pkgs.lixPackageSets.stable.lix;
  };
}
