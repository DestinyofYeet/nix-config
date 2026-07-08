{
  inputs,
  config,
  lib,
  ...
}:
let
  serverName = "ole.blue";
in
{
  services.anubis = {
    instances.homepage = {
      enable = true;

      settings = {
        TARGET = "unix:///run/nginx/nginx.sock";
      };
    };
  };

  systemd.services.anubis-homepage = {
    after = [ "nginx.service" ];

    serviceConfig = {
      ReadWritePaths = "/run/nginx/nginx.sock";
      DynamicUser = lib.mkForce false;
    };
  };

  services.nginx.virtualHosts = {
    "${serverName}-anubis" = {
      inherit serverName;

      forceSSL = true;
      enableACME = true;

      locations."/".proxyPass = "http://unix:${config.services.anubis.instances.homepage.settings.BIND}";
    };

    "${serverName}" = {
      inherit serverName;

      listen = [
        {
          addr = "unix:/run/nginx/nginx.sock";
        }
      ];

      locations."/".root = inputs.homepage.packages.x86_64-linux.default;
    };
  };

}
