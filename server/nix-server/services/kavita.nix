{ secretStore, config, lib, ... }:
let secrets = secretStore.get-server-secrets "nix-server";
in {

  age.secrets = { kavita-tokenkey.file = secrets + "/kavita-tokenkey.age"; };

  services.kavita = {
    enable = true;
    user = "apps";
    dataDir = "/mnt/data/configs/kavita";
    tokenKeyFile = config.age.secrets.kavita-tokenkey.path;
    settings = { Port = 5773; };
  };

  # users = {
  #   users."kavita" = {
  #     isSystemUser = true;
  #     group = "kavita";
  #   };

  #   groups."kavita" = { };
  # };

  services.nginx.virtualHosts."books.local.ole.blue" = {
    locations."/" = {
      proxyPass =
        "http://127.0.0.1:${toString config.services.kavita.settings.Port}";
    };
  } // lib.custom.settings.nix-server.nginx-local-ssl;
}
