{
  lib,
  config,
  pkgs,
  secretStore,
  stable-pkgs,
  options,
  ...
}:
let
  haUser = config.systemd.services."home-assistant".serviceConfig.User;
  haGroup = config.systemd.services."home-assistant".serviceConfig.Group;

  secrets = secretStore.getServerSecrets "nix-server";
in
{
  age.secrets = {
    ha_longitude = {
      file = secrets.getSecret "ha_longitude";
      owner = haUser;
      group = haGroup;
    };
    ha_latitude = {
      file = secrets.getSecret "ha_latitude";
      owner = haUser;
      group = haGroup;
    };
  };

  services.home-assistant = {
    enable = true;
    package = pkgs.home-assistant.override {
      packageOverrides = (
        self: super: {
          pycountry = pkgs.python314Packages.pycountry.overridePythonAttrs (old: rec {
            version = "24.6.1";

            # pycountry got updated which breaks radios which breaks home-assistant :)
            src = pkgs.fetchFromGitHub {
              owner = "pycountry";
              repo = "pycountry";
              tag = version;
              hash = "sha256-4YVPh6OGWguqO9Ortv+vAejxx7WLs4u0SVLv8JlKSWM=";
            };

          });
        }
      );
    };
    extraComponents = [
      "history"
      "mqtt"
      "mobile_app"
      "accuweather"
      "dwd_weather_warnings"
      "openweathermap"
      "weather"
      "ping"

      "isal"

      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      "upnp"
      "vodafone_station"
    ];

    # extraComponents = builtins.filter (
    #   elem:
    #   # check https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/servers/home-assistant/component-packages.nix
    #   # when something is broken to exclude it.
    #   # Look above the stack-trace message to see which dependency breaks for a python-package, then search for the python package.
    #   !(builtins.elem elem [

    #     # broken
    #     "aquacell"
    #     "aseko_pool_live"
    #     "bitcoin"
    #     "gdacs"
    #     "hydrawise"
    #     "influxdb"
    #     "nice_go"
    #     "sendgrid"
    #     "aten_pe"
    #     "august"
    #     "yale"
    #     "yalexs_ble"
    #     "aws"
    #     "aws_s3"
    #     "cloudflare_r2"
    #     "idrive_e2"
    #     "permobil"
    #     "raincloud"
    #     "twilio"
    #     "twilio_call"
    #     "twilio_sms"
    #     "kef"
    #   ])
    # ) config.services.home-assistant.package.availableComponents;

    config = {
      http = {
        server_host = "127.0.0.1";
        server_port = 8124;
      };

      homeassistant = {
        time_zone = "Europe/Berlin";
        unit_system = "metric";
        temperature_unit = "C";
        latitude = "!include ${config.age.secrets.ha_latitude.path}";
        longitude = "!include ${config.age.secrets.ha_longitude.path}";
      };

      automation = "!include automations.yaml";

      assist_pipeline = { };
      config = { };
      dhcp = { };
      energy = { };
      history = { };
      homeassistant_alerts = { };
      logbook = { };
      mobile_app = { };
      my = { };
      ssdp = { };
      stream = { };
      sun = { };
      usb = { };
      webhook = { };
      zeroconf = { };
    };
  };

  services.nginx.virtualHosts."automation.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl
    // {
      locations."/" =
        let
          haConfig = config.services.home-assistant.config.http;
        in
        {
          proxyPass = "http://${haConfig.server_host}:${toString haConfig.server_port}";
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
