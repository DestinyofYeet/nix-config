{ config, secretStore, lib, ... }:
let commonSecrets = secretStore.getServerSecrets "common";
in {
  imports = [ ../../parts/idp.nix ];

  age.secrets = {
    nix-authentik-env.file = commonSecrets + "/authentik-env.age";
  };

  services.authentik = {
    enable = true;
    environmentFile = config.age.secrets.nix-authentik-env.path;
  };

  # services.nginx.virtualHosts."${authentik-host}" =
  #   lib.custom.settings.nix-server.nginx-local-ssl // {
  #     locations."/" = {
  #       recommendedProxySettings = true;
  #       proxyWebsockets = true;
  #       proxyPass = "https://localhost:9443";
  #     };
  #   };

  systemd.services."authentik-worker".serviceConfig.LoadCredential = let

    idpCertDir = config.security.acme.certs."idp.ole.blue".directory;
  in [
    "idp.ole.blue.pem:${idpCertDir}/fullchain.pem"
    "idp.ole.blue.key:${idpCertDir}/key.pem"
  ];
}
