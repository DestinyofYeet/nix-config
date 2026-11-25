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
    session-secret.file = secrets.getSecret "bulwark-session-secret-key";
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
      jmapServerUrl = "https://mail.ole.blue";

      sessionSecretFile = config.age.secrets.session-secret.path;
      settingsSyncEnabled = true;
      stalwartFeaturesEnabled = true;
    };
  };

  services.nginx.virtualHosts =
    let
      cfg = config.services.bulwark;
    in
    {
      "webmail.ole.blue" = {
        enableACME = true;
        forceSSL = true;

        locations = {
          "/".proxyPass = "http://${cfg.hostname}:${toString cfg.port}";
        };
      };
    };
}
