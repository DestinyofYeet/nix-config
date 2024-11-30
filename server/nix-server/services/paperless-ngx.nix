{
  config,
  pkgs,
  ...
}:{
  age.secrets = {
    paperless-ngx-admin.file = ../secrets/paperless-ngx-admin.age;
  };

  services.paperless = {
    enable = true;

    dataDir = "${config.serviceSettings.paths.data}/paperless-ngx";

    settings = {
      PAPERLESS_URL = "https://paperless.local.ole.blue";
      PAPERLESS_OCR_USER_ARGS = "{\"continue_on_soft_render_error\": true}";
    };

    passwordFile = config.age.secrets.paperless-ngx-admin.path;

    inherit (config.serviceSettings) user;
  };

  services.nginx.virtualHosts."paperless.local.ole.blue" = config.serviceSettings.nginx-local-ssl // {
    locations."/".proxyPass = "http://${config.services.paperless.address}:${builtins.toString config.services.paperless.port}";
  };
}
