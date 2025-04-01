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
    authelia-ldap-pw = gen-secret "authelia-lldap-pw";

    authelia-jwt = gen-secret "authelia-jwt";
    authelia-oidc-hmac-secret = gen-secret "authelia-oidc-hmac-secret";

    authelia-oidc-private-key = gen-secret "authelia-oidc-private-key";

    authelia-session-secret = gen-secret "authelia-session-secret";

    authelia-storage-encryption-keys =
      gen-secret "authelia-storage-encryption-keys";

    authelia-email-ole-blue-pw = gen-secret "authelia-ole-blue-email-pw";

    authelia-oidc-client-jellyfin-id = gen-secret "authelia-openid-jellyfin-id";
    authelia-oidc-client-jellyfin-key =
      gen-secret "authelia-openid-jellyfin-key";

    authelia-oidc-client-forgejo-id = gen-secret "authelia-openid-forgejo-id";
    authelia-oidc-client-forgejo-key = gen-secret "authelia-openid-forgejo-key";

    authelia-oidc-client-nextcloud-id =
      gen-secret "authelia-openid-nextcloud-id";
    authelia-oidc-client-nextcloud-key =
      gen-secret "authelia-openid-nextcloud-key";

    authelia-oidc-client-paperless-id =
      gen-secret "authelia-openid-paperless-id";
    authelia-oidc-client-paperless-key =
      gen-secret "authelia-openid-paperless-key";

    authelia-oidc-client-immich-id = gen-secret "authelia-openid-immich-id";
    authelia-oidc-client-immich-key = gen-secret "authelia-openid-immich-key";

    authelia-oidc-client-wikijs-id = gen-secret "authelia-openid-wikijs-id";
    authelia-oidc-client-wikijs-key = gen-secret "authelia-openid-wikijs-key";

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
        identity_providers.oidc.clients = [
          {
            authorization_policy = "two_factor";
            client_name = "jellyfin";
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
          }
          {
            client_name = "Forgejo";
            client_id = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-forgejo-id.path}" }}'';
            client_secret = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-forgejo-key.path}" }}'';
            public = false;
            authorization_policy = "two_factor";
            redirect_uris =
              [ "https://code.ole.blue/user/oauth2/authelia/callback" ];
            scopes = [ "openid" "email" "profile" "groups" ];
            userinfo_signed_response_alg = "none";
            token_endpoint_auth_method = "client_secret_basic";
          }
          {
            client_name = "nextcloud";
            client_id = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-nextcloud-id.path}" }}'';
            client_secret = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-nextcloud-key.path}" }}'';
            public = false;
            authorization_policy = "one_factor";
            require_pkce = true;
            pkce_challenge_method = "S256";
            redirect_uris = [ "https://cloud.ole.blue/apps/user_oidc/code" ];
            scopes = [ "openid" "profile" "email" "groups" ];
            userinfo_signed_response_alg = "none";
            token_endpoint_auth_method = "client_secret_post";
          }
          {
            client_name = "paperless";
            client_id = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-paperless-id.path}" }}'';
            client_secret = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-paperless-key.path}" }}'';
            public = false;
            authorization_policy = "two_factor";
            require_pkce = true;
            pkce_challenge_method = "S256";
            redirect_uris = [
              "https://paperless.local.ole.blue/accounts/oidc/authelia/login/callback/"
            ];
            scopes = [ "openid" "profile" "email" "groups" ];
            userinfo_signed_response_alg = "none";
            token_endpoint_auth_method = "client_secret_basic";
          }
          {
            client_name = "immich";
            client_id = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-immich-id.path}" }}'';
            client_secret = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-immich-key.path}" }}'';
            public = false;
            authorization_policy = "two_factor";
            redirect_uris = [
              "https://images.local.ole.blue/auth/login"
              "https://images.local.ole.blue/user-settings"
              "app.immich:///oauth-callback"
            ];

            scopes = [ "openid" "profile" "email" ];
            userinfo_signed_response_alg = "none";
          }
          {
            client_name = "Wiki JS";
            client_id = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-wikijs-id.path}" }}'';
            client_secret = ''
              {{ secret "${config.age.secrets.authelia-oidc-client-wikijs-key.path}" }}'';
            public = false;
            authorization_policy = "two_factor";
            redirect_uris = [
              "https://wiki.local.ole.blue/login/e2c196dd-6667-46af-8517-d09e846afa82/callback"
            ];
            scopes = [ "openid" "email" "profile" "groups" ];
            userinfo_signed_response_alg = "none";
            token_endpoint_auth_method = "client_secret_post";
          }
        ];
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
              policy = "two_factor";
            }
            {
              domain = "*.local.ole.blue";
              policy = "two_factor";
            }
            {
              domain = "auth.ole.blue";
              policy = "bypass";
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

        server.endpoints.authz.auth-request = {
          implementation = "AuthRequest";
          authn_strategies = [
            {
              name = "HeaderAuthorization";
              schemes = [ "Basic" ];
            }
            { name = "CookieSession"; }
          ];
        };

        regulation = {
          max_retries = 5;
          find_time = "10m";
          ban_time = "12h";
        };
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
