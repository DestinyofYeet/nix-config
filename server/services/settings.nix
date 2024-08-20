{ lib, ... }:
let
  secrets = builtins.fetchGit {
    url = "git@github.com:DestinyofYeet/nix-secrets.git";
    rev = "216430c4ef4c2989f241f3119479369f702d6f7a";
    ref = "main";
  }; 
in {

  options.serviceSettings = with lib; {
    user = mkOption {
      type = types.str;
    };

    group = mkOption {
      type = types.str;
    };

    secrets = mkOption {
      type = types.attrs;
    };
  };

  config.serviceSettings = {
    user = "apps";
    group = "apps";

    secrets = import "${secrets}/secrets.nix" {};
  };
}
