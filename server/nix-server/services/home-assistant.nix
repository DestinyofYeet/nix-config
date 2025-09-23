{ lib, config, pkgs, ... }: {

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "zha" # zigbee
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
      };
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
