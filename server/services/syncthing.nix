{ config, ... }:{
  services.syncthing = {
    enable = true;
    settings = {
      folders = {
        camera = {
          path = "${config.serviceSettings.paths.data}/photos/handy/Camera";
          label = "Camera";
          id = "camera";

          devices = [ "handy" ];
        };

        default = {
          path = "${config.serviceSettings.paths.data}/syncthing/default-folder";
          label = "Default Folder";
          id = "default";
        };
      };

      devices = {
        handy = {
          name = "Handy";
          id = config.serviceSettings.secrets.syncthing.handy.id;
        };
      };

      gui = {
        user = "admin";
        password = "$2b$12$6/o5B5F0.L14z4AAa2beju7zKXELfXD/toTtH1iH8xQ4A7nX3vQE6";
      };
    };

    guiAddress = "0.0.0.0:8384";

    dataDir = "${config.serviceSettings.paths.data}/syncthing";

    inherit (config.serviceSettings) user group;
  };
}
