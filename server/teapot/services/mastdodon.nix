{ config, secretStore, ... }:
let secrets = secretStore.get-server-secrets "teapot";
in {
  age.secrets = {
    mastodon-email-password.file = secrets + "/mastodon_email_password.age";
  };

  services.mastodon = {
    enable = true;
    localDomain = "social.ole.blue";

    configureNginx = true;

    smtp = rec {
      createLocally = false;
      authenticate = true;

      host = "127.0.0.1";
      user = "mastodon@ole.blue";
      passwordFile = config.age.secrets.mastodon-email-password.path;

      fromAddress = user;
      port = 465;
    };

    streamingProcesses = 7;

    extraConfig.SINGLE_USER_MODE = "true";
  };
}
