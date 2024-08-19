{ config }:{
  services.syncthing = {
    enable = true;
    settings = {
      folders = {
        camera = {
          path = "/data/photos/handy/Camera";
          label = "Camera";
          id = "camera";
        };
      };

      devices = {
        handy = {
          name = "Handy";
          id = "handy";
        };
      };
    };

    inherit (config.serviceSettings) user group;
  };
}
