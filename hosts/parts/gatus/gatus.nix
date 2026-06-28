{
  domain,
  filter ? [ ],
}:
{
  secretStore,
  config,
  lib,
  ...
}:
let
  secrets = secretStore.getHostSecrets "common";
in
{

  age.secrets = {
    gatusEnv.file = secrets.getSecret "gatus-env";
  };

  services.gatus = {
    enable = true;

    environmentFile = config.age.secrets.gatusEnv.path;

    settings = {
      web = {
        address = "127.0.0.1";
        port = 9615;
      };

      ui = {
        title = "${config.networking.hostName} Uptime Monitoring";
      };

      alerting = {
        ntfy = {
          topic = "gatus";
          url = "https://ntfy.ole.blue";
          token = "$NTFY_TOKEN";

          default-alert = {
            enabled = true;
            failure-threshold = 2;
            send-on-resolved = true;
          };
        };
      };

      endpoints = [
        {
          name = "Self";
          url = "https://${domain}";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
          ];
        }
      ]
      ++ (lib.mapAttrsToList
        (name: value: {
          inherit name;

          url = "${if value.forceSSL then "https" else "http"}://${name}";
          interval = "60s";
          conditions = [
            "[STATUS] == 200"
          ];

          alerts = [
            {
              type = "ntfy";
            }
          ];

        })
        (
          lib.filterAttrs (
            name: value: name != domain && !(builtins.elem name filter)
          ) config.services.nginx.virtualHosts
        )
      );
    };
  };

  services.nginx.virtualHosts.${domain} = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      proxyWebsockets = true;
      proxyPass =
        let
          web = config.services.gatus.settings.web;
        in
        "http://${web.address}:${toString web.port}";
    };
  };
}
