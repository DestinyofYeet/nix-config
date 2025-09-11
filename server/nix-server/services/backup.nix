{ pkgs, secretStore, config, lib, ... }:
let
  secrets = secretStore.get-server-secrets "nix-server";

  default-opts = {
    initialize = true;

    timerConfig = {
      OnCalendar = "00:05";
      Persistent = true;
    };
  };

  mkRepoSecret = name: {
    "restic-repo-${name}".file = secrets + "/restic-repo-${name}.age";
    "restic-repo-${name}-pw".file = secrets + "/restic-repo-${name}-pw.age";
  };
in {
  age.secrets = { } // lib.mkMerge [
    (mkRepoSecret "photos")
    (mkRepoSecret "configs")
    (mkRepoSecret "documents")
  ];
  environment.systemPackages = with pkgs; [ restic ];

  services.restic.backups = {
    configs = default-opts // {
      repositoryFile = config.age.secrets.restic-repo-configs.path;
      paths = [ "/mnt/data/configs" ];
      passwordFile = config.age.secrets.restic-repo-configs-pw.path;
    };

    photos = default-opts // {
      repositoryFile = config.age.secrets.restic-repo-photos.path;
      paths = [ "/mnt/data/data/photos" ];
      passwordFile = config.age.secrets.restic-repo-photos-pw.path;
    };

    documents = default-opts // {
      repositoryFile = config.age.secrets.restic-repo-documents.path;
      paths = [ "/mnt/data/data/paperless-ngx" ];
      passwordFile = config.age.secrets.restic-repo-documents-pw.path;
    };
  };
}
