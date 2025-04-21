{ pkgs, secretStore, config, ... }:
let
  secrets = secretStore.get-server-secrets "nix-server";

  default-opts = { initialize = true; };
in {
  age.secrets = {
    restic-repo-configs.file = secrets + "/restic-repository-configs.age";
    restic-repo-configs-pw.file = secrets + "/restic-repo-configs-pw.age";
  };
  environment.systemPackages = with pkgs; [ restic ];
  services.restic.backups = {
    configs = default-opts // {
      timerConfig = {
        OnCalendar = "00:05";
        Persistent = true;
      };
      repositoryFile = config.age.secrets.restic-repo-configs.path;
      paths = [ "/mnt/data/configs" ];
      passwordFile = config.age.secrets.restic-repo-configs-pw.path;
    };
  };
}
