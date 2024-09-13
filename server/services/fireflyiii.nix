{ config, ... }:
let

  nixos-stable = builtins.fetchTarball {
    url = "https://github.com/nixos/nixpkgs/tarball/44a71ff39c182edaf25a7ace5c9454e7cba2c658";
    sha256 = "14w93hcmaa2jwg7ql2gsnh1s982smc599irk4ykkskg537v46n25";
  };
  pkgs-stable = import (nixos-stable) { system = config.nixpkgs.system; };
in {
  
  age.secrets = {
    app-key-file = { 
      file = ../secrets/fireflyiii-appkey.age; 
      owner = config.services.firefly-iii.user;
      group = config.services.firefly-iii.group;
    };
  };

  services.firefly-iii = {
    enable = true;

    package = pkgs-stable.firefly-iii;

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
