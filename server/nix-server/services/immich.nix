{ lib, config, pkgs, ... }: {
  services.immich = {
    enable = true;

    mediaLocation = "/mnt/data/data/immich";

    accelerationDevices = null;

    # settings.server.externalDomain = "https://images.local.ole.blue";
  };

  system.activationScripts = {
    "setfacl-immich".text = ''
      ${pkgs.acl}/bin/setfacl -m u:${config.services.immich.user}:rwx /mnt/data
      ${pkgs.acl}/bin/setfacl -m u:${config.services.immich.user}:rwx /mnt/data/data
      ${pkgs.acl}/bin/setfacl -R -m u:${config.services.immich.user}:rwx /mnt/data/data/immich
      # ${pkgs.acl}/bin/setfacl -R -m u:${config.services.immich.user}:rwx /mnt/data/data/photos
    '';
  };

  # systemd.tmpfiles = lib.mkIf config.services.immich.enable {
  #   rules = [
  #     "A+ /mnt/data/data/immich 0775 ${config.services.immich.user} ${config.services.immich.group}"
  #     "A+ /mnt/data/data/photos 0775 ${config.services.immich.user} ${config.services.immich.group}"
  #     "A+ /mnt/data/data/ 0755 ${config.services.immich.user} ${config.services.immich.group}"
  #   ];
  # };

  services.nginx.virtualHosts."images.local.ole.blue" =
    config.serviceSettings.nginx-local-ssl // {
      locations."/" = {
        proxyPass = "http://${config.services.immich.host}:${
            builtins.toString config.services.immich.port
          }";

        proxyWebsockets = true;
      };

      extraConfig = ''
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # set timeout
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
        send_timeout       600s;
      '';
    };
}
