{ lib, pkgs, config, secretStore, ... }:
let secrets = secretStore.getServerSecrets "nix-server";
in {

  age.secrets = {
    zigbee2mqttSecrets = {
      file = secrets + "/zigbee2mqtt-secrets.age";
      path = "${config.services.zigbee2mqtt.dataDir}/secrets.yaml";
      owner = config.systemd.services.zigbee2mqtt.serviceConfig.User;
      group = config.systemd.services.zigbee2mqtt.serviceConfig.Group;
    };
  };

  services.mosquitto = {
    enable = true;
    dataDir = "/mnt/data/data/mosquitto";
    listeners = [{
      address = "127.0.0.1";
      port = 1883;

      acl = [ "pattern readwrite #" ];
      omitPasswordAuth = true;
      settings.allow_anonymous = true;
    }];
  };

  systemd.services.mosquitto-setup = let
    mosquitto_user = config.systemd.services.mosquitto.serviceConfig.User;
    mosquitto_group = config.systemd.services.mosquitto.serviceConfig.Group;

    dataDir = config.services.mosquitto.dataDir;
  in rec {
    wantedBy = [ "mosquitto.service" ];
    requiredBy = wantedBy;

    script = let setfacl = lib.getExe' pkgs.acl "setfacl";
    in ''
      chown ${mosquitto_user}:${mosquitto_group} ${dataDir}

      ${setfacl} -d -m u:${mosquitto_user}:rwx ${dataDir}
      ${setfacl} -m u:${mosquitto_user}:rx /mnt/data/data
      ${setfacl} -m u:${mosquitto_user}:rx /mnt/data
    '';
  };

  systemd.services."zigbee2mqtt-setup" = rec {
    requiredBy = [ "zigbee2mqtt.service" ];
    before = requiredBy;
    script = let
      setfacl = lib.getExe' pkgs.acl "setfacl";
      service = config.systemd.services.zigbee2mqtt.serviceConfig;

      serviceUser = service.User;
      serviceGroup = service.Group;
      dataDir = config.services.zigbee2mqtt.dataDir;
    in ''
      chown ${serviceUser}:${serviceGroup} ${dataDir}

      ${setfacl} -d -m u:${serviceUser}:rwx ${dataDir}
      ${setfacl} -m u:${serviceUser}:rx /mnt/data/data
      ${setfacl} -m u:${serviceUser}:rx /mnt/data

    '';
  };

  services.zigbee2mqtt = {
    enable = true;
    dataDir = "/mnt/data/data/zigbee2mqtt";
    settings = {
      permit_join = true;
      serial.port = "/dev/ttyUSB0";
      frontend = {
        port = 8364;
        auth_token = "!secrets.yaml auth_token";
      };
      availability.enabled = true;
      homeassistant = lib.optionalAttrs config.services.home-assistant.enable {
        enable = true;
      };

      mqtt = {
        server = "mqtt://127.0.0.1:1883";
        base_topic = "zigbee2mqtt";
      };

    };
  };

  services.nginx.virtualHosts."z2mqtt.local.ole.blue" =
    lib.custom.settings.nix-server.nginx-local-ssl // {
      locations."/" = {
        proxyPass = "http://localhost:${
            toString config.services.zigbee2mqtt.settings.frontend.port
          }";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
}
