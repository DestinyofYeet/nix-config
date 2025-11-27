{ secretStore, config, lib, ... }:
let nixSecrets = secretStore.getServerSecrets "nix-server";
in {
  age.secrets = {
    teapot-authentik-env.file = nixSecrets + "/authentik-env.age";
  };

  services.postgresql = {
    ensureDatabases = [ "authentik" ];
    ensureUsers = [{
      name = "authentik";
      ensureDBOwnership = true;
    }];
  };

  systemd.services."authentik-migrate".enable = false;
  systemd.services."authentik".requires =
    lib.mkForce [ "authentik-worker.service" ];

  services.authentik = {
    enable = true;
    environmentFile = config.age.secrets.teapot-authentik-env.path;

    createDatabase = false;

    nginx = {
      enable = true;
      enableACME = true;
      host = "idp.ole.blue";
    };

    settings = {
      postgresql = {
        host = "/run/postgresql";
        user = "authentik";
        name = "authentik";
      };
    };
  };
}
