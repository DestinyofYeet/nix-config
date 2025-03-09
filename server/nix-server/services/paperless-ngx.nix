{ config, pkgs, lib, secretStore, ... }:
let secrets = secretStore.get-server-secrets "nix-server";
in {
  age.secrets = {
    paperless-ngx-admin.file = ../secrets/paperless-ngx-admin.age;
    paperless-ngx-authelia-env-file.file = secrets
      + "/paperless-authelia-env-file.age";
  };

  services.paperless = {
    enable = true;

    dataDir = "${
        lib.custom.settings.${config.networking.hostName}.paths.data
      }/paperless-ngx";

    settings = {
      PAPERLESS_URL = "https://paperless.local.ole.blue";
      PAPERLESS_OCR_USER_ARGS = ''{"continue_on_soft_render_error": true}'';
    };

    passwordFile = config.age.secrets.paperless-ngx-admin.path;

    environmentFile = config.age.secrets.paperless-ngx-authelia-env-file.path;

    inherit (lib.custom.settings.${config.networking.hostName}) user;
  };

  services.nginx.virtualHosts."paperless.local.ole.blue" =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // {
      locations."/".proxyPass = "http://${config.services.paperless.address}:${
          builtins.toString config.services.paperless.port
        }";

      extraConfig = ''
        proxy_set_header Host $host;
        proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-Host $http_host;
        proxy_set_header X-Forwarded-URI $request_uri;
        proxy_set_header X-Forwarded-Ssl on;
        proxy_set_header X-Forwarded-For $remote_addr;
        proxy_set_header X-Real-IP $remote_addr;

      '';
    };
}
