{
  config,
  lib,
  ...
}:

let 

  nixos-stable = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/44a71ff39c182edaf25a7ace5c9454e7cba2c658";
    sha256 = "14w93hcmaa2jwg7ql2gsnh1s982smc599irk4ykkskg537v46n25";
  };
  pkgs-stable = import (nixos-stable) { system = "x86_64-linux"; };
in {
  options.customSettings = with lib; {
    stable-pkgs = mkOption {
      type = mkOptionType {
        name = "nixpkgs";
      };
    };
  };

  config.customSettings = {
    stable-pkgs = pkgs-stable;
  };
}

