{ config, stable-pkgs, pkgs, lib, custom, ... }: {

  age.secrets = {
    app-key-file = {
      file = ../secrets/fireflyiii-appkey.age;
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
    };
  };

  services.firefly-iii = {
    enable = true;

    package = pkgs.firefly-iii;

    settings = {
      APP_KEY_FILE = config.age.secrets.app-key-file.path;
      APP_URL = "https://firefly.local.ole.blue";
      TZ = "Europe/Berlin";
      DEFAULT_LOCALE = "de_DE";
    };

    dataDir = "${
        lib.custom.settings.${config.networking.hostName}.paths.configs
      }/fireflyiii";

    # virtualHost = "firefly.nix-server.infra.wg";
    virtualHost = "firefly.local.ole.blue";

    enableNginx = true;

    # inherit (config.serviceSettings) user group;
  };

  services.nginx.virtualHosts.${config.services.firefly-iii.virtualHost} = {
    enableACME = false;
    useACMEHost =
      lib.custom.settings.${config.networking.hostName}.nginx-local-ssl.useACMEHost;
    forceSSL = true;
  };
}
