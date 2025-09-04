{ config, pkgs, ... }: {
  age.secrets = {
    cache-priv-key = {
      file = ../../secrets/nix-serve-priv-key.age;
      mode = "600";
      owner = "nix-serve";
      group = "nix-serve";
    };
  };

  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    secretKeyFile = config.age.secrets.cache-priv-key.path;
  };
}
