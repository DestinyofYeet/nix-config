{ lib, ... }:
let
  # for this to work, the ssh key needs to be in /root/.ssh and the /root/.ssh/config file has to have a github.com Hostname thingy
  secrets = builtins.fetchGit {
    url = "git@github.com:DestinyofYeet/nix-secrets.git";
    rev = "a63ed48562b5c101b089c7b77c68d0708ee9d132";
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
