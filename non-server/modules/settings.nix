{
  config,
  lib,
  ...
}:

let 

  nixos-stable = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/30439d93eb8b19861ccbe3e581abf97bdc91b093";
    sha256 = "1fa67745sf5f9mdz4slkk814dzn93bi72k25wafi21w74mw43id3";  # done with nix-prefetch-url --unpack
  };
  pkgs-stable = import (nixos-stable) { system = "x86_64-linux"; };
in {
  options.customSettings = with lib; {
    stable-pkgs = mkOption {
      type = mkOptionType {
        name = "nixpkgs";
      };
    };

    currentEditor = mkOption {
      type = types.str;
    };
  };

  config.customSettings = {
    stable-pkgs = pkgs-stable;
    currentEditor = "hx";
  };
}

