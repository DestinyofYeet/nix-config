{ config, secretStore, lib, ... }:
let
  secrets = secretStore.getServerSecrets "nix-server";
  authentik-host = "idp.local.ole.blue";
in {
  age.secrets = { nix-authentik-env.file = secrets + "/authentik-env.age"; };

  services.authentik = {
    enable = true;
    environmentFile = config.age.secrets.nix-authentik-env.path;

    settings = { cert_discovery_dir = "env://CREDENTIALS_DIRECTORY"; };
  };

  services.nginx.virtualHosts."${authentik-host}" =
    lib.custom.settings.nix-server.nginx-local-ssl // {
      locations."/" = {
        recommendedProxySettings = true;
        proxyWebsockets = true;
        proxyPass = "https://localhost:9443";
      };
    };

  systemd.services."authentik-worker".serviceConfig.LoadCredential = [
    "${authentik-host}.pem:${
      config.security.acme.certs."wildcard.local.ole.blue".directory
    }/fullchain.pem"
    "${authentik-host}.key:${
      config.security.acme.certs."wildcard.local.ole.blue".directory
    }/key.pem"
  ];
}
