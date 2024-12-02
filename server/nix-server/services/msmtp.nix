{
  config,
  ...
}:{

  age.secrets = {
    email-firefly-iii-credentials.file = ../secrets/firefly-email-credentials.age;
    zed-email-credentials = { file = ../secrets/zed-email-credentials.age; };
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
      firefly = {
        auth = true;
        passwordeval = "cat ${config.age.secrets.email-firefly-iii-credentials.path}";
        user = "firefly-iii@ole.blue";
        from = "firefly-iii@ole.blue";
      };

      default = {
        passwordeval = "cat ${config.age.secrets.zed-email-credentials.path}";
        user = "zed@ole.blue";
        from = "zed@ole.blue";
      };
    };
  };
}
