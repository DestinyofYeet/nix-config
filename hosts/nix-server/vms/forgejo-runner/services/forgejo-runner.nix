{ secretStore, config, pkgs, ... }:
let secrets = secretStore.getServerSecrets "nix-server/vms/forgejo-runner";
in {
  age.secrets = {
    forgejo-runner-registration-token.file = secrets
      + "/forgejo-registration-token.age";
  };

  services.gitea-actions-runner.instances."code-ole-blue" = {
    enable = true;

    url = "https://code.ole.blue";
    name = "nix-server";
    labels = [ "native:host" ];
    tokenFile = config.age.secrets.forgejo-runner-registration-token.path;
    hostPackages = with pkgs; [ nix nodejs gnutar gzip bash git ];
  };

}
