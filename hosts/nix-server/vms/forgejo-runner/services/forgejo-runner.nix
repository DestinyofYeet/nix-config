{
  secretStore,
  config,
  pkgs,
  flake,
  ...
}:
let
  secrets = secretStore.getHostSecrets "nix-server/vms/forgejo-runner";
in
{
  age.secrets = {
    forgejo-runner-registration-token.file = secrets.getSecret "forgejo-registration-token";
  };

  services.gitea-actions-runner.instances."git-ole-blue" = {
    enable = true;

    url = "https://${
      flake.nixosConfigurations."teapot".config.services.forgejo.settings.DEFAULT.APP_NAME
    }";
    name = "nix-server";
    labels = [ "native:host" ];
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

}
