{ lib, config, pkgs, secretStore, ... }:
let
  haUser = config.systemd.services."home-assistant".serviceConfig.User;
  haGroup = config.systemd.services."home-assistant".serviceConfig.Group;

  secrets = secretStore.getServerSecrets "nix-server";
in {
  age.secrets = {
    ha_longitude = {
      file = secrets + "/ha_longitude.age";
      owner = haUser;
      group = haGroup;
    };
    ha_latitude = {
      file = secrets + "/ha_latitude.age";
      owner = haUser;
      group = haGroup;
    };
  };

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "zha" # zigbee
      "mobile_app"
    ];

    config = {
      http = {
        server_host = "127.0.0.1";
        server_port = 8123;
      };

      homeassistant = {
        time_zone = "Europe/Berlin";
        unit_system = "metric";
        temperature_unit = "C";
        latitude = "!include ${config.age.secrets.ha_latitude.path}";
        longitude = "!include ${config.age.secrets.ha_longitude.path}";
      };

      automation = "!include automations.yaml";

      default_config = { };
    };
  };

  services.nginx.virtualHosts."automation.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl // {
      locations."/" = let haConfig = config.services.home-assistant.config.http;
      in {
        proxyPass =
          "http://${haConfig.server_host}:${toString haConfig.server_port}";
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

        client_max_body_size 0;
      '';
    };
}
