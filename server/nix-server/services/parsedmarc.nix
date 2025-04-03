{ config, secretStore, lib, ... }:
let secrets = secretStore.get-server-secrets "nix-server";
in {
  age.secrets = {
    dmarc-ole-blue-email-pw.file = secrets + "/dmarc-ole-blue-password.age";
    maxmind-license-key = rec {
      file = secrets + "/maxmind-license-key.age";
      owner = "geoip";
      group = owner;
    };
  };
  services.parsedmarc = {
    enable = true;
    provision = {
      grafana.dashboard = true;
      elasticsearch = true;
    };

    settings = rec {
      imap = {
        host = "mail.ole.blue";
        ssl = true;
        port = 993;
        password = config.age.secrets.dmarc-ole-blue-email-pw.path;
        user = "dmarc@ole.blue";
      };

      smtp = {
        inherit (imap) host user password;
        ssl = true;
        port = 587;
        from = imap.user;
        to = [ "ole@ole.blue" ];
      };

      elasticsearch = { ssl = false; };

      mailbox.watch = true;
    };
  };

  services.geoipupdate = {
    enable = true;
    settings = {
      AccountID = 1149846;
      LicenseKey = config.age.secrets.maxmind-license-key.path;
      EditionIDs = [ "GeoLite2-ASN" "GeoLite2-City" "GeoLite2-Country" ];
    };
  };

  systemd.services."geoipupdate".serviceConfig.DynamicUser = lib.mkForce false;
  systemd.services."geoipupdate".serviceConfig.User = "geoip";

  users = {
    users."geoip" = {
      isSystemUser = true;
      group = "geoip";
    };

    groups.geoip = { };
  };
}
