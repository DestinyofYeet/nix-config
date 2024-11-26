{ config, ... }:{

  containers.postgresql = {
    autoStart = false;

    bindMounts = {
      "/var/lib/postgresql-custom" = {
        hostPath = "${config.serviceSettings.paths.data}/postgresql"; 
        isReadOnly = false;
      };
    };

    config = { config, pkgs, lib, ...} : {
    
      services.postgresql = {
        enable = true;

        dataDir = "/var/lib/postgresql-custom";

        settings.port = 54321;
      };

      system.stateVersion = "24.05";
    };
  };

}
