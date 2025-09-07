{ config, secretStore, ... }:
let secrets = secretStore.getServerSecrets "teapot";
in {
  age.secrets = {
    github-runner-strichliste-rs.file = secrets
      + "/github-runners-strichliste-rs.age";
  };
  services.github-runners = {
    "strichliste-rs" = {
      enable = true;
      name = "teapot";
      url = "https://github.com/strichliste-rs";
      user = null;
      group = null;
      tokenFile = config.age.secrets.github-runner-strichliste-rs.path;
    };
  };
}
