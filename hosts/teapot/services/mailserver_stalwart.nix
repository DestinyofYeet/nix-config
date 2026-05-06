{
  config,
  lib,
  pkgs,
  secretStore,
  ...
}:
let
  secrets = secretStore.getHostSecrets "teapot";
  commonSecrets = secretStore.getHostSecrets "common";

  ownership = {
    owner = config.services.stalwart.user;
    group = config.services.stalwart.group;
  };

  getCredential = string: "%{file:/run/credentials/stalwart.service/${string}}%";

in
{

  age.secrets = {
    stalwart-admin = {
      file = secrets.getSecret "stalwart-admin";
    }
    // ownership;

    stalwart-db = {
      file = secrets.getSecret "stalwart-db";
    }
    // ownership;

    stalwart-ldap = {
      file = secrets.getSecret "stalwart-ldap";
    }
    // ownership;

    cloudflare-api-key = {
      file = commonSecrets.getSecret "cloudflare-api-token";
    }
    // ownership;
  };

  services.postgresql = {
    ensureDatabases = [ "stalwart" ];
    ensureUsers = [
      {
        name = "stalwart";
        ensureDBOwnership = true;
      }
    ];
  };

  users.users.${config.services.stalwart.user} = {
    extraGroups = [ "nginx" ];
  };

  # security.acme.certs.${config.services.stalwart.settings.server.hostname} = {
  #   dnsProvider = "cloudflare";
  #   webroot = null;
  #   extraDomainNames = [
  #     "uwuwhatsthis.de"
  #     "drogen.gratis"
  #   ];
  # };

  services.stalwart = {
    enable = true;
    stateVersion = "26.05";
    openFirewall = true;

    credentials = {
      stalwart-db = config.age.secrets.stalwart-db.path;
      stalwart-admin = config.age.secrets.stalwart-admin.path;
      stalwart-ldap = config.age.secrets.stalwart-ldap.path;
      cloudflare-api-key = config.age.secrets.cloudflare-api-key.path;
    };

    settings = rec {
      server = {
        hostname = "mail.ole.blue";

        tls = {
          enable = true;
          implicit = true;
        };

        listener = {
          smtp = {
            protocol = "smtp";
            bind = "[::]:25";
          };

          submissions = {
            bind = "[::]:465";
            protocol = "smtp";
            tls.implicit = true;
          };

          imaps = {
            bind = "[::]:993";
            protocol = "imap";
            tls.implicit = true;
          };

          jmap = {
            bind = "[::]:8081";
            protocol = "http";
            url = "https://mail.ole.blue";
          };

          sieve = {
            protocol = "managesieve";
            bind = [ "[::]:4190" ];
          };

          management = {
            bind = [ "127.0.0.1:8082" ];
            protocol = "http";
            url = "https://manage.mail.ole.blue";
          };
        };
      };

      http = {
        use-x-forwarded = true;
        permissive-cors = true;
      };

      store.postgres = {
        type = "postgresql";
        # host = "bonk.neb.ole.blue";
        # port = 5432;
        # database = "stalwart";
        # user = "stalwart";
        # # password = getCredential "stalwart-db";
        # password = "$2a$10$9M168KN/inkKB3uPO2GyteNJhBmO3EJjdcHvkMayM52TN6nNRXevS";
        host = "localhost";
        database = "stalwart";
        user = "stalwart";
        password = "stupid";
      };

      # certificate.default = {
      #   cert = "%{file:${config.security.acme.certs.${server.hostname}.directory}/cert.pem}%";
      #   private-key = "%{file:${config.security.acme.certs.${server.hostname}.directory}/key.pem}%";
      # };

      directory."authentik" = {
        base-dn = "ou=users,dc=ldap,dc=idp";
        type = "ldap";
        url = "ldaps://idp.ole.blue:636";
        tls.enable = false;
        bind = {
          dn = "cn=stalwartLdap,ou=users,dc=ldap,dc=idp";
          secret = getCredential "stalwart-ldap";
          auth.method = "lookup";
        };

        attributes = {
          secret-changed = "pwdChangedTime";
          name = "cn";
          email = "mail";
          class = "objectClass";
          groups = "memberOf";
          email-alias = "emailAliases";
          quota = "diskQuota";
        };

        filter = {
          email = "(&(objectClass=person)(|(mail=?)(mailAlias=?)))";
          name = "(&(objectClass=person)(mail=?))";
        };
      };

      storage = {
        encryption = {
          enable = true;
          append = true;
        };

        data = "postgres";
        blob = "postgres";
        fts = "postgres";
        lookup = "postgres";
        directory = "authentik";
      };

      authentication.fallback-admin = {
        user = "admin";
        secret = "$argon2id$v=19$m=65540,t=3,p=4$0jnx1MfU/FGZfH70keifD8m8YJpqm71NjrtpB5j76TI$3a3SkjgNkUjyAXDY4rMWBneJGVVvbitLc5UoDOkrKnA";
      };

      lookup.default = {
        hostname = "mail.ole.blue";
      };

      tracer.journal = {
        type = "log";
        level = "info";
        path = "/var/lib/stalwart/logs/";
      };

      # configured in webinterface
      # acme."cf" = {
      #   provider = "cloudflare";
      #   contact = "ole@ole.blue";
      #   email = "bendiixeno@hotmail.de";
      #   secret = getCredential "cloudflare-api-key";
      #   challengeType = "dns-01";
      #   domains = [
      #     "mail.ole.blue"
      #     "drogen.gratis"
      #     "uwuwhatsthis.de"
      #   ];
      # };
    };
  };

  networking.firewall.allowedTCPPorts = [
    25
    587
    465
    4190
  ];

  security.acme.certs = {
    "mgm.mail.ole.blue" = { };
  };

  services.nginx.virtualHosts."mgm.mail.ole.blue" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://localhost:8082";
      recommendedProxySettings = true;
      proxyWebsockets = true;
    };
  };

  services.roundcube = {
    enable = true;

    dicts = with pkgs.aspellDicts; [
      en
      de
    ];

    plugins = [
      "managesieve"
    ];

    hostName = "mail.ole.blue";
    extraConfig = ''
      $config['imap_host'] = "ssl://mail.ole.blue:993";

      $config['smtp_host'] = "ssl://mail.ole.blue:465";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";

      $config['managesieve_port'] = '4190';
      $config['managesieve_host'] = '127.0.0.1';
      $config['managesieve_auth_type'] = 'PLAIN';
      $config['managesieve_usetls'] = false;

    '';
    # $config['virtuser_file'] = "${virtuser_file}";
    # u

    configureNginx = true;
  };

}
