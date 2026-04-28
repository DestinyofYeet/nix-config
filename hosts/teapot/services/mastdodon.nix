{ config, secretStore, ... }:
let
  secrets = secretStore.getServerSecrets "teapot";
in
{
  age.secrets = {
    mastodon-email-password = {
      file = secrets.getSecret "mastodon_email_password";
      group = "mastodon";
      owner = "mastodon";
    };
  };

  services.mastodon = {
    enable = true;
    localDomain = "drogen.gratis";

    configureNginx = true;

    smtp = rec {
      createLocally = false;
      authenticate = true;

      host = "mail.ole.blue";
      user = "mastodon@drogen.gratis";
      passwordFile = config.age.secrets.mastodon-email-password.path;

      fromAddress = user;
      port = 465;
    };

    streamingProcesses = 7;

    extraConfig = {
      SMTP_SSL = "true";
      SMTP_TLS = "true";
      SMTP_ENABLE_STARTTLS_AUTO = "true";
      SMTP_OPENSSL_VERIFY_MODE = "none";
      SMTP_DELIVERY_METHOD = "smtp";
    };
  };
}
