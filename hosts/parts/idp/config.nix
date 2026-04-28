{
  secretStore,
  config,
  lib,
  ...
}:
let
  secrets = secretStore.getServerSecrets "common";

  machines = import ../../../custom/nebula/machines.nix;
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
      authentik-ldap-env.file = secrets.getSecret "authentik-ldap-env";
      authentik-env.file = secrets.getSecret "authentik-env";
      authentik-db = {
        file = secrets.getSecret "authentik-db-pass";
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
      listen = {

        http = "${machines.${config.networking.hostName}.ip}:7689";
        ldaps = "${machines.${config.networking.hostName}.ip}:6748";
      };
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
          host = "bonk.neb.ole.blue";
          port = 5432;

          read_replicas = {
            "0" = {
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
