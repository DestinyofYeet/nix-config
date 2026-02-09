{
  config,
  pkgs,
  secretStore,
  ...
}:
let
  secrets = secretStore.getServerSecrets "teapot";
in
{
  age.secrets = {
    cache-priv-key = {
      file = secrets + "/nix-serve-priv-key.age";
      mode = "600";
      owner = "nix-serve";
      group = "nix-serve";
    };
  };

  services.nix-serve = {
    enable = true;
    package = pkgs.nix-serve-ng;
    bindAddress = "127.0.0.1";
    secretKeyFile = config.age.secrets.cache-priv-key.path;
  };

  users = {
    users.nix-serve = {
      isSystemUser = true;
      group = "nix-serve";
    };

    groups.nix-serve = { };
  };

  services.nginx.virtualHosts."cache.ole.blue" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://${config.services.nix-serve.bindAddress}:${toString config.services.nix-serve.port}";
    };
  };
}
