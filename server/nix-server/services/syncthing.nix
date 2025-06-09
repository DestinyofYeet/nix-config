{ config, lib, ... }: {
  services.syncthing = {
    enable = true;
    settings = {
      folders = {
        camera = {
          path = "${
              lib.custom.settings.${config.networking.hostName}.paths.data
            }/photos/handy/Camera";
          label = "Camera";
          id = "camera";

          devices = [ "handy" ];
        };

        whatsapp = {
          path = "${
              lib.custom.settings.${config.networking.hostName}.paths.data
            }/photos/handy/whatsapp_media";
          label = "WhatsApp Media";
          id = "whatsapp_media";

          devices = [ "handy" ];

          ignores = [ "Private/" "Sent/" ];
        };

        default = {
          path = "${
              lib.custom.settings.${config.networking.hostName}.paths.data
            }/syncthing/default-folder";
          label = "Default Folder";
          id = "default";
        };
      };

      devices = {
        handy = {
          name = "Handy";
          id =
            lib.custom.settings.${config.networking.hostName}.secrets.syncthing.handy.id;
          numconnections = 10;
        };
      };

      gui = {
        user = "admin";
        password =
          "$2b$12$6/o5B5F0.L14z4AAa2beju7zKXELfXD/toTtH1iH8xQ4A7nX3vQE6";
      };
    };

    guiAddress = "127.0.0.1:8384";

    dataDir = "${
        lib.custom.settings.${config.networking.hostName}.paths.data
      }/syncthing";

    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };

  services.nginx = let
    default-config = {
      locations."/" = { proxyPass = "http://127.0.0.1:8384"; };
    };
  in {
    virtualHosts = {
      "syncthing.local.ole.blue" =
        lib.custom.settings.${config.networking.hostName}.nginx-local-ssl
        // default-config;
    };
  };
}
