{ config, secretStore, stable-pkgs, ... }:
let secrets = secretStore.get-server-secrets "teapot";
in {

  age.secrets = { mealie-env-file.file = secrets + "/mealie_env_file.age"; };

  # nixpkgs.config.allowBroken = true;

  services.mealie = {
    enable = true;
    # package = stable-pkgs.mealie;
    settings = {
      ALLOW_SIGNUP = "false";
      BASE_URL = "https://recipes.ole.blue";
      LOG_LEVEL = "debug";

      OIDC_AUTH_ENABLED = "true";
      OIDC_SIGNUP_ENABLED = "true";
      OIDC_CONFIGURATION_URL =
        "https://idp.ole.blue/application/o/mealie/.well-known/openid-configuration";
      OIDC_PROVIDER_NAME = "Authentik";
      OIDC_USER_GROUP = "mealie";
      OIDC_ADMIN_GROUP = "mealieAdmin";
      OIDC_AUTO_REDIRECT = "false";
      OIDC_GROUPS_CLAIM = "groups";
    };
    listenAddress = "127.0.0.1";
    credentialsFile = config.age.secrets.mealie-env-file.path;
    port = 9002;
  };

  services.nginx.virtualHosts."recipes.ole.blue" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://${config.services.mealie.listenAddress}:${
          toString config.services.mealie.port
        }";

      extraConfig = ''
        proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-URI $request_uri;
        proxy_set_header X-Forwarded-Ssl on;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Real-IP $remote_addr;
      '';
    };
  };
}
