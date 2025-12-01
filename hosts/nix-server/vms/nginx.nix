{ lib, config, ... }: {

  services.nginx.virtualHosts."wiki.local.ole.blue" =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl // {
      locations."/".proxyPass = "http://192.168.3.10:3002";
    };
}
