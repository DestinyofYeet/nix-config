{ config, ... }:{
  
  age.secrets = {
    app-key-file = { 
      file = ../secrets/fireflyiii-appkey.age; 
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
    };
  };

  services.firefly-iii = {
    enable = true;

    settings = {
      APP_KEY_FILE = config.age.secrets.app-key-file.path;
      APP_URL = "https://firefly.nix-server.infra.wg";
      TZ = "Europe/Berlin";
      DEFAULT_LOCALE = "de_DE";
    };

    dataDir = "${config.serviceSettings.paths.configs}/fireflyiii";

    # virtualHost = "firefly.nix-server.infra.wg";
    virtualHost = "firefly.uwuwhatsthis.de";

    enableNginx = true;

    # inherit (config.serviceSettings) user group;
  };
}
