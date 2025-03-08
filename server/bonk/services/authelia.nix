{ lib, secretStore, config, ... }:
let
  secrets = secretStore.get-server-secrets "bonk";

  authelia-instance = "main";
  authelia-user = "authelia-${authelia-instance}";

  authelia-age = {
    owner = authelia-user;
    group = authelia-user;
  };

  authelia-secrets-dir = "/var/lib/authelia/${authelia-instance}/secrets";

  gen-secret = name: {
    file = secrets + "/${name}.age";
    path = authelia-secrets-dir + "/${name}";
    owner = authelia-user;
    group = authelia-user;
  };
in {
  age.secrets = {
    authelia-ldap-pw = {
      file = secrets + "/authelia-lldap-pw.age";
    } // authelia-age;
    authelia-jwt = {
      file = secrets + "/authelia-jwt.age";
      path = "${authelia-secrets-dir}/authelia-jwt";
    } // authelia-age;
    authelia-oidc-hmac-secret = {
      file = secrets + "/authelia-oidc-hmac-secret.age";
      path = "${authelia-secrets-dir}/authelia-oidc-hmac-secret";
    } // authelia-age;
    authelia-oidc-private-key = {
      file = secrets + "/authelia-oidc-private-key.age";
      path = "${authelia-secrets-dir}/authelia-oidc-private-key";
    } // authelia-age;
    authelia-session-secret = {
      file = secrets + "/authelia-session-secret.age";
      path = "${authelia-secrets-dir}/authelia-session-secret";
    } // authelia-age;
    authelia-storage-encryption-keys = {
      file = secrets + "/authelia-storage-encryption-keys.age";
      path = "${authelia-secrets-dir}/authelia-storage-encryption-keys";
    } // authelia-age;

    authelia-email-ole-blue-pw = gen-secret "authelia-ole-blue-email-pw";

    authelia-oidc-client-jellyfin-id = gen-secret "authelia-openid-jellyfin-id";
    authelia-oidc-client-jellyfin-key =
      gen-secret "authelia-openid-jellyfin-key";

  };

  services.authelia = {
    instances.${authelia-instance} = {
      enable = true;
      settings = {
        notifier.smtp = {
          address = "submissions://mail.ole.blue:465";
          username = "auth@ole.blue";
          password = ''
            {{ secret "${config.age.secrets.authelia-email-ole-blue-pw.path}" }}'';
          sender = "Authelia <auth@ole.blue>";
        };
        identity_providers.oidc.clients = [{
          authorization_policy = "one_factor";
          client_id = ''
            {{ secret "${config.age.secrets.authelia-oidc-client-jellyfin-id.path}" }}'';
          client_secret = ''
            {{ secret "${config.age.secrets.authelia-oidc-client-jellyfin-key.path}" }}'';
          redirect_uris =
            [ "https://jellyfin.local.ole.blue/sso/OID/redirect/authelia" ];
          scopes = [ "openid" "profile" "groups" ];
          userinfo_signed_response_alg = "none";
          token_endpoint_auth_method = "client_secret_post";
          public = false;
          require_pkce = true;
          pkce_challenge_method = "S256";
        }];
        # server.address = "9091"; # default is tcp :9091
        theme = "dark";
        default_2fa_method = "totp";
        authentication_backend.ldap = {
          address = "ldap://nix-server.neb.ole.blue:3890";
          base_dn = "dc=ole,dc=blue";
          users_filter =
            "(&(|({username_attribute}={input})({mail_attribute}={input}))(objectClass=person))";
          groups_filter = "(member={dn})";
          user = "uid=authelia,ou=people,dc=ole,dc=blue";
        };

        access_control = {
          default_policy = "deny";

          rules = lib.mkAfter [
            {
              domain = "*.ole.blue";
              policy = "one_factor";
            }
            {
              domain = "*.local.ole.blue";
              policy = "one_factor";
            }
          ];
        };

        storage.postgres = {
          address = "unix:///run/postgresql";
          database = "authelia-main";
          # complains without it
          username = "authelia-main";
          password = "authelia-main";
        };

        session = {
          redis = { host = "/var/run/redis-authelia/redis.sock"; };
          cookies = [{
            domain = "ole.blue";
            authelia_url = "https://auth.local.ole.blue";
            inactivity = "1M";
            expiration = "3M";

            remember_me = "1y";
          }];
        };

        identity_providers.oidc = {
          cors = {
            endpoints = [ "token" ];
            allowed_origins_from_client_redirect_uris = true;
          };
          authorization_policies.default = {
            default_policy = "one_factor";
            rules = [{
              policy = "deny";
              subject = "group:lldap_strict_readonly";
            }];
          };
        };

        server.endpoints.authz.forward-auth.implementation = "AuthRequest";
      };

      secrets = with config.age.secrets; {
        jwtSecretFile = authelia-jwt.path;
        oidcIssuerPrivateKeyFile = authelia-oidc-private-key.path;
        oidcHmacSecretFile = authelia-oidc-hmac-secret.path;
        sessionSecretFile = authelia-session-secret.path;
        storageEncryptionKeyFile = authelia-storage-encryption-keys.path;
      };

      environmentVariables = {
        AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE =
          config.age.secrets.authelia-ldap-pw.path;
      };
    };
  };

  services.nginx.virtualHosts."auth.ole.blue" = {
    enableACME = true;
    forceSSL = true;

    locations."/".proxyPass = "http://localhost:9091";

    extraConfig = ''
      ## Headers
      proxy_set_header Host $host;
      proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Host $http_host;
      proxy_set_header X-Forwarded-URI $request_uri;
      proxy_set_header X-Forwarded-Ssl on;
      proxy_set_header X-Forwarded-For $remote_addr;
      proxy_set_header X-Real-IP $remote_addr;

      ## Basic Proxy Configuration
      client_body_buffer_size 128k;
      proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; ## Timeout if the real server is dead.
      proxy_redirect  http://  $scheme://;
      proxy_http_version 1.1;
      proxy_cache_bypass $cookie_session;
      proxy_no_cache $cookie_session;
      proxy_buffers 64 256k;

      real_ip_header X-Forwarded-For;
      real_ip_recursive on;

      send_timeout 5m;
      proxy_read_timeout 360;
      proxy_send_timeout 360;
      proxy_connect_timeout 360;
    '';
  };

  services.redis.servers.authelia.enable = true;

  systemd.services.${authelia-user} =
    let deps = [ "postgresql.service" "redis-authelia.service" ];
    in {
      after = deps;
      requires = deps;
    };

  users.users."${config.services.authelia.instances.main.user}".extraGroups =
    [ "redis-authelia" ];
}
