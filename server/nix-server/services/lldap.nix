{ secretStore, lib, config, ... }:
let
  secrets = secretStore.get-server-secrets "nix-server";

  lldap-user = "lldap";
  lldap-group = "lldap";
in {
  age.secrets = {
    lldap-jwt-secret = {
      file = secrets + "/lldap-jwt-secret.age";
      owner = lldap-user;
      group = lldap-group;
    };

    lldap-key-seed = {
      file = secrets + "/lldap-key-seed.age";
      owner = lldap-user;
      group = lldap-group;
    };

    lldap-user-pass = {
      file = secrets + "/lldap-user-pass.age";
      owner = lldap-user;
      group = lldap-group;
    };
  };

  services.lldap = {
    enable = true;
    settings = {
      ldap_base_dn = "dc=ole,dc=blue";
      ldap_user_email = "postmaster@ole.blue";
      database_url = "postgresql://lldap@localhost/lldap?host=/run/postgresql";
      force_ldap_user_pass_reset = "always";
    };
    environment = {
      LLDAP_JWT_SECRET_FILE = config.age.secrets.lldap-jwt-secret.path;
      LLDAP_KEY_SEED_FILE = config.age.secrets.lldap-key-seed.path;
      LLDAP_LDAP_USER_PASS_FILE = config.age.secrets.lldap-user-pass.path;
    };
  };

  services.nginx.virtualHosts."users.local.ole.blue" =
    lib.custom.settings."nix-server".nginx-local-ssl // {
      locations."/".proxyPass =
        "http://localhost:${toString config.services.lldap.settings.http_port}";
    };

  systemd.services.lldap = let deps = [ "postgresql.service" ];
  in {
    after = deps;
    requires = deps;

    serviceConfig.DynamicUser = lib.mkForce false;
  };

  users = {
    users.lldap = {
      group = "lldap";
      isNormalUser = true;
    };

    groups.lldap = { };
  };
}
