{
  config,
  secretStore,
  ...
}:
let
  secrets = secretStore.getHostSecrets "common";
in
{
  age.secrets = {
    admin-hash.file = secrets.getSecret "bulwark-admin-hash";
  };

  services.bulwark = {
    enable = true;
    port = 8961;
    hostname = "localhost";

    admin = {
      passwordHashFile = config.age.secrets.admin-hash.path;
    };

    settings = {
      appName = "Webmail";
      jmapServerUrl = "https://mail.musicbot.info";
    };
  };

  services.nginx.virtualHosts =
    let
      cfg = config.services.bulwark;
    in
    {
      "webmail.musicbot.info" = {
        enableACME = true;
        forceSSL = true;

        locations = {
          "/".proxyPass = "http://${cfg.hostname}:${toString cfg.port}";
        };
      };
    };
}
