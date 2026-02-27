{
  config,
  pkgs,
  lib,
  secretStore,
  ...
}:
let
  secrets = secretStore.get-server-secrets "nix-server";
in
{
  age.secrets = {
    paperless-ngx-admin.file = ../secrets/paperless-ngx-admin.age;
    paperless-ngx-oidc-env-file.file = secrets + "/paperless-oidc-env-file.age";
  };

  services.paperless = rec {
    enable = true;

    domain = "paperless.local.ole.blue";

    dataDir = "${lib.custom.settings.${config.networking.hostName}.paths.data}/paperless-ngx";

    settings = {
      PAPERLESS_URL = "https://${domain}";
      PAPERLESS_OCR_USER_ARGS = ''{"continue_on_soft_render_error": true}'';
      PAPERLESS_LOGOUT_REDIRECT_URL = "https://idp.ole.blue/application/o/paperless/end-session/";
      PAPERLESS_AUTO_LOGIN = true;
      PAPERLESS_AUTO_CREATE = true;
      PAPERLESS_SOCIAL_AUTO_SIGNUP = true;
      PAPERLESS_SOCIALACCOUNT_ALLOW_SIGNUPS = true;
    };

    passwordFile = config.age.secrets.paperless-ngx-admin.path;

    environmentFile = config.age.secrets.paperless-ngx-oidc-env-file.path;

    inherit (lib.custom.settings.${config.networking.hostName}) user;
  };

  services.nginx.virtualHosts."${config.services.paperless.domain}" =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl
    // {
      locations."/".proxyPass =
        "http://${config.services.paperless.address}:${toString config.services.paperless.port}";

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-URI $request_uri;
        proxy_set_header X-Forwarded-Ssl on;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Real-IP $remote_addr;

        client_max_body_size 0;
      '';
    };
}
