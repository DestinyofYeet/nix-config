{
  secretStore,
  config,
  lib,
  inputs,
  ...
}:
let
  secrets = secretStore.getServerSecrets "common";
in
{
  age.secrets =
    let
      ownership = {

        owner = "authentik";
        group = "authentik";
      };
    in
    {
      authentik-ldap-env.file = secrets + "/authentik-ldap-env.age";
      authentik-env.file = secrets + "/authentik-env.age";
      authentik-db = {
        file = secrets + "/authentik-db-pass.age";
      }
      // ownership;
    };

  users = {
    users.authentik = {
      isSystemUser = true;
      group = "authentik";
    };

    groups.authentik = { };
  };

  imports = [
    inputs.authentik-nix.nixosModules.default
    ./cert.nix
  ];

  systemd.services."authentik-worker".serviceConfig.LoadCredential =
    let

      idpCertDir = config.security.acme.certs."idp.ole.blue".directory;
    in
    [
      "idp.ole.blue.pem:${idpCertDir}/fullchain.pem"
      "idp.ole.blue.key:${idpCertDir}/key.pem"
    ];

  services.authentik = {
    enable = true;
    createDatabase = false;

    environmentFile = config.age.secrets.authentik-env.path;

    settings = {
      cert_discovery_dir = "env://CREDENTIALS_DIRECTORY";
      email = {
        host = "mail.ole.blue";
        port = 465;
        username = "authentik@ole.blue";
        use_ssl = true;
        from = "Authentik <authentik@ole.blue>";
        timeout = 30;
      };

      postgresql =
        let
          pgsqlPw = {

            name = "authentik";
            user = "authentik";
            password = "file://${config.age.secrets.authentik-db.path}";
          };
        in
        {
          host = "teapot.neb.ole.blue";
          port = 5432;

          read_replicas = {
            "0" = {
              host = "teapot.neb.ole.blue";
              port = 5433;
            }
            // pgsqlPw;

            "1" = {
              host = "bonk.neb.ole.blue";
              port = 5433;
            }
            // pgsqlPw;
          };
        }
        // pgsqlPw;
    };
  };

  services.authentik-ldap = {
    enable = true;

    environmentFile = config.age.secrets.authentik-ldap-env.path;
  };
}
