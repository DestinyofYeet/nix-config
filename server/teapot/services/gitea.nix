{ config, lib, pkgs, secretStore, ... }: {

  age.secrets = {
    forgejo-env-file.file = secretStore.secrets
      + "/servers/teapot/forgejo_env_file.age";
  };

  services.forgejo = {
    enable = true;

    package = pkgs.forgejo;

    database = {
      type = "postgres";
      socket = "/run/postgresql";
    };

    settings = {
      DEFAULT = { APP_NAME = "git.ole.blue"; };

      indexer = { REPO_INDEXER_ENABLED = true; };

      session = { COOKIE_SECURE = true; };

      service = {
        # DISABLE_REGISTRATION = true; 
        # REGISTER_MANUAL_CONFIRM = true;

        # ENABLE_NOTIFY_MAIL = true;

        # ENABLE_CAPTCHA = true;
        DISABLE_REGISTRATION = false;
        ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
        SHOW_REGISTRATION_BUTTON = false;
      };

      openid = {
        ENABLE_OPENID_SIGNIN = false;
        ENABLE_OPENID_SIGNUP = true;
        WHITELISTED_URIS = "auth.ole.blue";
      };

      federation = { ENABLED = true; };

      security = {
        INSTALL_LOCK = true;
        PASSWORD_COMPLEXITY = "spec";
        PASSWORD_CHECK_PWN = true;
      };

      mailer = rec {
        ENABLED = true;
        PROTOCOL = "smtps";
        SMTP_ADDR = "mail.ole.blue";
        SMTP_PORT = 465;
        USER = "forgejo@ole.blue";
        FROM = USER;
        ENVELOPE_FROM = USER;
      };

      server = {
        ROOT_URL = "https://git.ole.blue";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3005;
        DOMAIN = "git.ole.blue";
      };

      log = { LEVEL = "Debug"; };
    };
  };

  systemd.services."forgejo".serviceConfig.EnvironmentFile =
    config.age.secrets.forgejo-env-file.path;

  services.nginx.virtualHosts."git.ole.blue" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass =
        "http://${config.services.forgejo.settings.server.HTTP_ADDR}:${
          toString config.services.forgejo.settings.server.HTTP_PORT
        }";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_set_header Connection $http_connection;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        client_max_body_size 0;
      '';
    };
  };
}
