{ secretStore, config, lib, ... }:
let commonSecrets = secretStore.getServerSecrets "common";
in {
  age.secrets = {
    teapot-authentik-env.file = commonSecrets + "/authentik-env.age";
  };
  imports = [ ../../parts/idp.nix ];

  services.postgresql = {
    ensureDatabases = [ "authentik" ];
    ensureUsers = [{
      name = "authentik";
      ensureDBOwnership = true;
    }];
  };

  systemd.services = lib.mkIf (config.services.authentik.enable) {
    "authentik-migrate".enable = false;
    "authentik".requires = lib.mkForce [ "authentik-worker.service" ];
    "authentik-worker".serviceConfig.LoadCredential =
      let certDir = config.security.acme.certs."idp.ole.blue".directory;
      in [
        "idp.ole.blue.pem:${certDir}/fullchain.pem"
        "idp.ole.blue.key:${certDir}/key.pem"
      ];
  };

  services.authentik = {
    enable = true;
    environmentFile = config.age.secrets.teapot-authentik-env.path;

    createDatabase = false;

    settings = {
      cert_discovery_dir = "env://CREDENTIALS_DIRECTORY";
      postgresql = {
        host = "/run/postgresql";
        user = "authentik";
        name = "authentik";
      };
    };
  };
}
