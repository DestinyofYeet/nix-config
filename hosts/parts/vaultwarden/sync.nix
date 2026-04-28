{
  config,
  lib,
  ...
}:
{
  users = {
    users = {
      vaultwarden = {
        isSystemUser = true;
        group = "vaultwarden";
      };

      syncthing = {
        isSystemUser = true;
        group = "syncthing";
        extraGroups = [ "vaultwarden" ];
      };
    };

    groups = {
      vaultwarden = { };
      syncthing = { };
    };
  };

  services.syncthing = {
    user = "syncthing";
    group = "syncthing";

    settings = {
      folders = {
        "${config.services.vaultwarden.config.DATA_DIR}" = {
          id = "vaultwarden";
          ignorePerms = true;
          devices = builtins.filter (elem: elem != config.networking.hostName) [
            "nix-server"
            "teapot"
          ];
        };
      };
    };
  };

  systemd.services.vaultwarden.serviceConfig.StateDirectoryMode = lib.mkForce 770;
  systemd.services.syncthing.serviceConfig.CapabilityBoundingSet = [ "CAP_CHOWN" ];

  systemd.services."vaultwarden-setup" = rec {
    requiredBy = [ "vaultwarden.service" ];
    wantedBy = requiredBy;
    script =
      let
        dataDir = config.services.vaultwarden.config.DATA_DIR;
      in
      ''
        chmod -R 770 ${dataDir}
        chmod -R g+s ${dataDir}
      '';
  };
}
