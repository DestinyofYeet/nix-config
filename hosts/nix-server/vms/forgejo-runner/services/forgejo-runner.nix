{
  secretStore,
  config,
  pkgs,
  flake,
  ...
}:
let
  secrets = secretStore.getHostSecrets "nix-server/vms/forgejo-runner";

  forgejo_url = "https://${
    flake.nixosConfigurations."teapot".config.services.forgejo.settings.DEFAULT.APP_NAME

  }";
in
{
  age.secrets = {
    forgejo-runner-token.file = secrets.getSecret "forgejo-runner-token";
  };

  services.forgejo-runner.instances = {
    "global-1-native" = {
      settings = {
        secrets = {
          server.connections."git.ole.blue".token = config.age.secrets.forgejo-runner-token.path;
        };

        hostPackages = with pkgs; [
          nix
          nodejs
          gnutar
          gzip
          bash
          git
        ];

        runner = {
          labels = [
            "native:host"
            "rust:docker://rust:1.97.1"
            "ubuntu:docker://ubuntu:26.04"
            "debian:docker://debian:stable-20260803"
          ];
        };

        server.connections."git.ole.blue" = {

          url = forgejo_url;
          uuid = "cdc08825-f314-42e6-a1d3-802e50161e09";
        };
      };
    };
  };

}
