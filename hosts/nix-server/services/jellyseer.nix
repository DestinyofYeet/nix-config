{ pkgs, lib, config, ... }:
let
  serviceUser = "jellyseerr";
  serviceName = "jellyseerr";
in {
  imports = [
    ({ lib, ... }: {
      systemd.services.${serviceName}.serviceConfig = {
        User = lib.mkForce serviceUser;
        DynamicUser = lib.mkForce false;
        ProtectSystem = lib.mkForce false;
      };
    })
  ];

  services.jellyseerr = {
    enable = true;
    configDir = "/mnt/data/configs/jellyseer/config";
  };

  users = {
    users.${serviceUser} = {
      isSystemUser = true;
      group = serviceUser;
    };

    groups.${serviceUser} = { };
  };

  systemd.services."${serviceName}-setup" = let

    setfacl = (lib.getExe' pkgs.acl "setfacl");
  in rec {
    script = ''
      ${setfacl} -d -m u:${serviceUser}:rwx /mnt/data/configs/jellyseer
      ${setfacl} -m u:${serviceUser}:rx /mnt/data/configs
    '';

    requiredBy = [ "${serviceName}.service" ];
    before = requiredBy;
  };

  services.nginx.virtualHosts."requests.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl // {
      locations."/" = {
        proxyPass =
          "http://localhost:${toString config.services.jellyseerr.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
}
