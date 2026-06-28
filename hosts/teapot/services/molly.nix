{
  config,
  secretStore,
  ...
}:
let
  secrets = secretStore.getHostSecrets "teapot";
in
{

  age.secrets = {
    mollysocketEnv.file = secrets.getSecret "mollysocket-env";
  };

  services.mollysocket = {
    enable = true;

    environmentFile = config.age.secrets.mollysocketEnv.path;

    settings = {
      allowed_endpoints = [ "https://ntfy.ole.blue" ];
      allowed_uuids = [ "*" ];

      host = "127.0.0.1";
      port = 8425;
    };
  };

  services.nginx.virtualHosts."molly.ole.blue" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyWebsockets = true;

      proxyPass =
        let
          settings = config.services.mollysocket.settings;
        in
        "http://${settings.host}:${toString settings.port}";
    };
  };
}
