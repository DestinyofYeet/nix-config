{
  lib,
  pkgs,
  config,
  ...
}:
let
  user = "actual";
  group = user;
  dataDir = "/mnt/data/data/actual";
in

{
  services.actual = {
    enable = true;

    settings = {
      inherit dataDir;

      port = 7282;
      hostname = "localhost";
    };

    inherit group user;
  };

  services.nginx.virtualHosts."budget.local.ole.blue" =
    let
      actualSettings = config.services.actual.settings;
    in
    lib.custom.settings.nix-server.nginx-local-ssl
    // {
      locations."/" = {
        proxyWebsockets = true;
        recommendedProxySettings = true;

        proxyPass = "http://${actualSettings.hostname}:${toString actualSettings.port}";
      };
    };

  users = {
    users.${user} = {
      isSystemUser = true;

      inherit group;
    };

    groups.${group} = { };
  };

  systemd.services."actual-setup" = rec {
    wantedBy = [ "actual.service" ];
    requiredBy = wantedBy;

    script =
      let
        setfacl = lib.getExe' pkgs.acl "setfacl";
      in
      ''
        chown ${user}:${group} ${dataDir}

        ${setfacl} -d -m u:${user}:rwx ${dataDir}
        ${setfacl} -m u:${user}:rx /mnt/data/data
        ${setfacl} -m u:${user}:rx /mnt/data
      '';
  };
}
