{
  lib,
  config,
  pkgs,
  ...
}:
let
  # for this to work, the ssh key needs to be in /root/.ssh and the /root/.ssh/config file has to have a github.com Hostname thingy
  secrets = builtins.fetchGit {
    url = "git@github.com:DestinyofYeet/nix-secrets.git";
    rev = "0ee6b577a3159cd252ad59a3a652dd5cedc3b7f0";
    ref = "main";
  };

  nixos-stable = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/44a71ff39c182edaf25a7ace5c9454e7cba2c658";
    sha256 = "14w93hcmaa2jwg7ql2gsnh1s982smc599irk4ykkskg537v46n25";
  };

  mkStringOpt = lib.mkOption {
    type = lib.types.str;
  };
in
{

  options.serviceSettings = with lib; {
    user = mkOption {
      type = types.str;
    };

    group = mkOption {
      type = types.str;
    };

    uid = mkStringOpt;
    gid = mkStringOpt;

    secrets = mkOption {
      type = types.attrs;
    };

    paths = {
      data = mkStringOpt;
      configs = mkStringOpt;
    };

    scripts = mkOption {
      type = types.attrs;
    };

    stable-pkgs = mkOption {
      type = mkOptionType {
        name = "nixpkgs";
      };
    };

    nginx-local-ssl = mkOption {
      type = types.attrs;
    };
  };

  config.serviceSettings = {
    user = "apps";
    group = "apps";

    uid = builtins.toString config.users.users.${config.serviceSettings.user}.uid;
    gid = builtins.toString config.users.groups.${config.serviceSettings.group}.gid;

    secrets = import "${secrets}/secrets.nix" { };

    paths.data = "/mnt/data/data";
    paths.configs = "/mnt/data/configs";

    stable-pkgs = import nixos-stable { system = "x86_64-linux"; };

    nginx-local-ssl = {
      forceSSL = true;
      useACMEHost = "wildcard.local.ole.blue";
    };
  };
}
