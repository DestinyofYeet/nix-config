{
  config,
  ...
}:
{

  age.secrets = {
    email-firefly-iii-credentials.file = ../secrets/firefly-email-credentials.age;
    email-uptime-kuma.file = ../secrets/email-uptime-kuma.age;
    zed-email-credentials = {
      file = ../secrets/zed-email-credentials.age;
    };
  };

  programs.msmtp = {
    enable = true;
    setSendmail = true;

    defaults = {
      aliases = "/etc/aliases";
      port = 465;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      tls = "on";
      auth = true;
      tls_starttls = "off";
      host = "mail.ole.blue";
    };

    accounts = {
      firefly = rec {
        passwordeval = "cat ${config.age.secrets.email-firefly-iii-credentials.path}";
        user = "firefly-iii@ole.blue";
        from = user;
      };

      default = rec {
        passwordeval = "cat ${config.age.secrets.zed-email-credentials.path}";
        user = "zed@ole.blue";
        from = user;
      };
    };
  };
}
