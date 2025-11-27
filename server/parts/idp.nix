{ secretStore, config, ... }:
let commonSecrets = secretStore.getServerSecrets "common";
in {
  age.secrets = {
    authentik-ldap-env.file = commonSecrets + "/authentik-ldap-env.age";
  };

  services.authentik = {
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
    };
  };

  services.authentik-ldap = {
    enable = true;

    environmentFile = config.age.secrets.authentik-ldap-env.path;
  };
}
