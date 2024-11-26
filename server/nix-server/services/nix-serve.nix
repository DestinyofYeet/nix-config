{ config, ... }:{
  age.secrets = {
    cache-priv-key = { 
      file = ../secrets/nix-serve-priv-key.age;
      mode = "600";
      owner = "nix-serve";
      group = "nix-serve";
    };
  };

  services.nix-serve = {
    enable = true;
    secretKeyFile = config.age.secrets.cache-priv-key.path;
  };
}
