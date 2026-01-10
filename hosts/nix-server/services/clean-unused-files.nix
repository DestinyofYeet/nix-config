{ config, secretStore, ... }:
let secrets = secretStore.getServerSecrets "nix-server";
in {
  age.secrets = {
    clean-unused-files-config.file = secrets + "/clean-unused-files.age";
  };

  services.clean-unused-files = {
    enable = true;

    configFile = config.age.secrets.clean-unused-files-config.path;

    dataDir = "/mnt/data/data/clean_unused_files";
  };
}
