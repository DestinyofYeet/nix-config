{
  config,
  lib,
  ...
}:
{
  services.shoko = {
    enable = true;
  };

  systemd.services.shoko.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "apps";
    Group = "apps";
  };

  services.nginx =
    let
      default-config = {
        locations."/" = {
          proxyPass = "http://localhost:8111";
        };
      };
    in
    {
      virtualHosts = {
        "shoko.local.ole.blue" =
          lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // default-config;
      };
    };
}
