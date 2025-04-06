{ config, pkgs, secretStore, ... }:
let
  cat = "${pkgs.coreutils}/bin/cat";
  secrets = secretStore.get-server-secrets "nix-server";
in {

  age.secrets = {
    email-firefly-iii-credentials.file =
      ../secrets/firefly-email-credentials.age;
    email-uptime-kuma.file = ../secrets/email-uptime-kuma.age;
    zed-email-credentials = { file = ../secrets/zed-email-credentials.age; };

    msmtp-ole-blue.file = secrets + "/msmtp-ole-blue.age";
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
        passwordeval =
          "${cat} ${config.age.secrets.email-firefly-iii-credentials.path}";
        user = "firefly-iii@ole.blue";
        from = user;
      };

      smartd = {
        passwordeval = "${cat} ${config.age.secrets.msmtp-ole-blue.path}";
        user = "msmtp@ole.blue";
        from = "smartd@ole.blue";
      };

      default = rec {
        passwordeval =
          "${cat} ${config.age.secrets.zed-email-credentials.path}";
        user = "zed@ole.blue";
        from = user;
      };
    };
  };
}
