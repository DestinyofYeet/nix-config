{ config, lib, ... }:
{
  services.syncthing = {
    enable = true;
    settings = {
      folders = {
        camera = {
          path = "${lib.custom.settings.${config.networking.hostName}.paths.data}/photos/handy/Camera";
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

          ignores = [
            "Private/"
            "Sent/"
          ];
        };

        deposit = {
          path = "${lib.custom.settings.nix-server.paths.data}/syncthing/deposit";
          label = "Deposit";
          id = "deposit";

          devices = [
            "handy"
            "laptop"
            "desktop"
          ];

        };

        default = {
          path = "${lib.custom.settings.${config.networking.hostName}.paths.data}/syncthing/default-folder";
          label = "Default Folder";
          id = "default";
        };
      };

      devices = {
        handy = {
          name = "Handy";
          id = "SLOYG5Q-RMVBV5F-E5MO32D-DYCKEV5-A7K74AX-EKGAEJW-HPDIHER-4FJK6AR";
          numconnections = 10;
        };

        laptop = {
          name = "Laptop";
          id = "R64O662-MPFMBSU-WPY4DAB-SLKRVUD-C3XHVZB-ODYGO5K-KBGUSN6-SPA2RQ2";
          numconnections = 10;
        };

        desktop = {
          name = "Desktop";
          id = "VAWV3TD-OVTR26J-4W5YPSI-CDHD4FX-Y3XENDC-6QHAJT5-ZRJJMNQ-HRMNKQL";
          numconnections = 10;
        };

        teapot = {
          id = "7RLIZB4-X3YZGN7-DKNI2I5-T25R745-AWHBZZZ-BNKOI7F-37QYTYW-CMQ7EQD";
          numconnections = 10;
        };
      };

      gui = {
        user = "admin";
        password = "$2b$12$6/o5B5F0.L14z4AAa2beju7zKXELfXD/toTtH1iH8xQ4A7nX3vQE6";
      };
    };

    guiAddress = "127.0.0.1:8384";

    dataDir = "${lib.custom.settings.${config.networking.hostName}.paths.data}/syncthing";
  };

  services.nginx =
    let
      default-config = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8384";
        };
      };
    in
    {
      virtualHosts = {
        "syncthing.local.ole.blue" =
          lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
      };
    };
}
