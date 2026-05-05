{
  config,
  lib,
  secretStore,
  ...
}:
let
  secrets = secretStore.getHostSecrets "teapot";

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

  # systemd.services.stalwart.environment = {
  #   STALWART_RECOVERY_MODE = "1";
  #   STALWART_RECOVERY_MODE_PORT = "8085";
  #   STALWART_RECOVERY_ADMIN = "admin:xZ5IatGUtx1JX9cuYqRuEeabaWLJRWlVWKM9Jol0";
  # };

  services.stalwart = {
    enable = true;
    stateVersion = "26.05";
    openFirewall = true;
    credentials = {
      stalwart-admin = config.age.secrets.stalwart-admin.path;
      stalwart-db = config.age.secrets.stalwart-db.path;
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
            url = "https://mail.example.org";
            protocol = "http";
          };
          management = {
            bind = [ "127.0.0.1:8082" ];
            protocol = "http";
          };
        };
      };
      lookup.default = {
        hostname = "mail.ole.blue";
        domain = "ole.blue";
      };
      # acme."letsencrypt" = {
      #   directory = "https://acme-v02.api.letsencrypt.org/directory";
      #   challenge = "dns-01";
      #   contact = "user1@example.org";
      #   domains = [
      #     "example.org"
      #     "mx1.example.org"
      #   ];
      #   provider = "cloudflare";
      #   secret = "%{file:/run/credentials/stalwart.service/acme-secret}%";
      # };
      certificate.default = {
        cert = "%{file:${config.security.acme.certs.${server.hostname}.directory}/cert.pem}%";
        private-key = "%{file:${config.security.acme.certs.${server.hostname}.directory}/key.pem}%";
      };

      storage.directory = "authentik";
      directory."authentik" = {
        type = "oidc";
        description = "Authentik";
        issuerUrl = "https://idp.ole.blue/application/o/stalwart/";
        claimName = "name";
      };
      authentication.fallback-admin = {
        user = "admin";
        secret = "%{file:/run/credentials/stalwart.service/stalwart-admin}%";
      };
    };
  };

  # virtualisation.oci-containers.containers."stalwart" = {
  #   image = "stalwartlabs/stalwart:v0.16";
  #   volumes = [
  #     "/var/lib/stalwart/config:/etc/stalwart"
  #     "/var/lib/stalwart/data:/var/lib/stalwart"
  #   ];
  #   ports = [
  #     "8082:8080"
  #     "25:25"
  #     "587:587"
  #     "465:465"
  #     "4190:4190"
  #   ];
  # };

  # networking.firewall.allowedTCPPorts = [
  #   25
  #   587
  #   465
  #   4190
  # ];

  services.nginx.virtualHosts."mail.ole.blue" = {
    enableACME = true;
    forceSSL = true;

    serverAliases = [
      "mta-sts.ole.blue"
      "autoconfig.ole.blue"
      "autodiscover.ole.blue"
    ];

    locations."/" = {
      proxyPass = "http://localhost:8082";
      recommendedProxySettings = true;
      proxyWebsockets = true;
    };
  };
}
