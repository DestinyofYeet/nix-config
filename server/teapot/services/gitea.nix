{
  config,
  ...
}:
{
  age.secrets = {
    postgresql-gitea-password.file = ../secrets/postgresql-gitea-password.age;
  };

  services.gitea = {
    enable = true;

    useWizard = true;

    appName = "git.ole.blue";

    database = {
      type = "postgres";
      # socket = "/run/postgresql";
      passwordFile = config.age.secrets.postgresql-gitea-password.path;
      host = "10.100.0.4";
    };

    settings = {
      session = {
        COOKIE_SECURE = true;
      };

      service = {
        DISABLE_REGISTRATION = true;
      };

      server = {
        ROOT_URL = "https://git.ole.blue";
        HTTP_ADDR = "127.0.0.1";
        HTTP_PORT = 3005;
        DOMAIN = "git.ole.blue";
      };

      log = {
        LEVEL = "debug";
      };
    };
  };

  services.nginx.virtualHosts."git.ole.blue" = {
    forceSSL = true;
    enableACME = true;
    locations."/" = {
      proxyPass = "http://${config.services.gitea.settings.server.HTTP_ADDR}:${toString config.services.gitea.settings.server.HTTP_PORT}";
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
