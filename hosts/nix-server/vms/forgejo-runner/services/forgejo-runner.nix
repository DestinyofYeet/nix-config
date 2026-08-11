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
    forgejo-runner-registration-token.file = secrets.getSecret "forgejo-registration-token";
  };

  services.gitea-actions-runner.instances = {
    "global-1-native" = {
      enable = true;

      url = forgejo_url;
      name = "global-1";

      labels = [
        "native:host"
        "rust:docker://rust:1.97.1"
        "ubuntu:docker://ubuntu:26.04"
        "debian:docker://debian:stable-20260803"
      ];

      tokenFile = config.age.secrets.forgejo-runner-registration-token.path;
      hostPackages = with pkgs; [
        nix
        nodejs
        gnutar
        gzip
        bash
        git
      ];
    };
  };

}
