{
  inputs, lib
}:
let
  git-secrets = builtins.fetchGit {
    url = "git@github.com:DestinyofYeet/nix-secrets.git";
    rev = "0ee6b577a3159cd252ad59a3a652dd5cedc3b7f0";
    ref = "main";
  };
in {
  mkIfLaptop = config : attr : 
    lib.mkIf (config.networking.hostName == "wattson") attr;

  mkIfMainElse = config : attr : default : 
    if (config.networking.hostName == "main") then attr else default;

  settings = rec {
    editor = "hx";

    system = "x86_64-linux";

    screenshot-cmd = "${inputs.nixpkgs.legacyPackages.${system}.hyprshot}/bin/hyprshot -m window -m region --clipboard-only";

    nix-server = {

      secrets = import "${git-secrets}/secrets.nix" {};

      paths.data = "/mnt/data/data";
      paths.configs = "/mnt/data/configs";
      
      user = "apps";
      group = "apps";

      uid = "568";
      gid = "568";
      
      nginx-local-ssl = {
        forceSSL = true;
        useACMEHost = "wildcard.local.ole.blue";
      };
    };
  };
}
