{ pkgs, config, secretStore, ... }:
let secrets = secretStore.get-server-secrets "teapot";
in {
  age.secrets = {
    ole-mail.file = ../secrets/ole-ole.blue.age;
    scripts-uwuwhatsthis-de.file = ../secrets/scripts-uwuwhatsthis.de.age;
    sonarr-uwuwhatsthis-de.file = ../secrets/sonarr-uwuwhatsthis.de.age;
    prowlarr-uwuwhatsthis-de.file = ../secrets/prowlarr-uwuwhatsthis.de.age;
    uptime-kuma-uwuwhatsthis-de.file = ../secrets/prowlarr-uwuwhatsthis.de.age;

    firefly-iii-ole-blue.file = ../secrets/firefly-email-credentials.age;
    zed-uwuwhatsthis-de.file = ../secrets/zed-uwuwhatsthis.de.age;
    hydra-uwuwhatsthis-de.file = ../secrets/hydra-uwuwhatsthis.de.age;

    nextcloud-uwuwhatsthis-de.file = ../secrets/nextcloud-uwuwhatsthis.de.age;
    nextcloud-ole-blue.file = ../secrets/nextcloud-ole-blue.age;

    postgresql-roundcube-password.file =
      ../secrets/postgresql-roundcube-password.age;

    forgejo-email-ole-blue.file = secretStore.secrets
      + "/servers/teapot/forgejo_email_password.age";

    authelia-email-ole-blue.file = secrets
      + "/authelia-hashed-email-password.age";

    dmarc-email-ole-blue.file = secrets + "/dmarc-hashed-email-password.age";

    msmtp-email-ole-blue.file = secrets + "/msmtp-ole-blue.age";
  };

  mailserver = {
    enable = true;
    fqdn = "mail.ole.blue";

    stateVersion = 3;

    useUTF8FolderNames = true;

    systemDomain = "ole.blue";

    dmarcReporting = {
      enable = true;
      organizationName = "ole";
    };

    domains = [ "ole.blue" "uwuwhatsthis.de" "drogen.gratis" ];

    fullTextSearch = {
      enable = true;
      autoIndex = true;
      enforced = "body";
    };

    enableManageSieve = true;

    monitoring = {
      enable = true;
      alertAddress = "ole@ole.blue";
    };

    # somehow nukes my nameserver entries in /etc/resolv.conf and no more ns lookups are possible
    localDnsResolver = false;

    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "ole@ole.blue" = {
        hashedPasswordFile = "${config.age.secrets.ole-mail.path}";

        sieveScript = ''
          require ["fileinto"];

          if address "From" "scripts@uwuwhatsthis.de" {
            fileinto "INBOX.scripts";
          } elsif address "From" "sonarr@ole.blue" {
            fileinto "INBOX.sonarr";
          } elsif address "From" "prowlarr@uwuwhatsthis.de" {
            fileinto "INBOX.prowlarr";
          }

          if anyof (
            header :contains "to" "postmaster@ole.blue",
            header :contains "to" "postmaster@uwuwhatsthis.de"
          ) {
            fileinto "INBOX.postmaster";
          } elsif anyof (
            header :contains "to" "abuse@ole.blue",
            header :contains "to" "abuse@uwuwhatsthis.de"
          ){
            fileinto  "INBOX.abuse";
          }
        '';

        aliases = [
          "paypal@ole.blue"
          "KzEDlTbbJi0vJmCkUXKm@ole.blue"
          "unikat@ole.blue"
          "nG1TULuBBQn7sIqAXFv@ole.blue"
          "a3RS62ERLYMwAJGbCWqu@ole.blue"
          "A0M0adWle4WGr2TfXRfA@ole.blue"
          "txMuOMD3DXwXoZgNW0d1@ole.blue"
          "zkVJ2tnuohYj0RDYpZTh@ole.blue"
          "r5k7LrdJkUIcSnd8F79h@ole.blue"
          "HpvBfL5udRAY71pHPTTL@ole.blue"
          "fCYPExKAaBvxmXY8gL4h@ole.blue"
          "k2qWxFkzDjrE3VSZ1C8X@ole.blue"
          "0wmgydMvJugr9o7ZSbHx@ole.blue"
          "BR09q6rAxWMg0kOHkwA5@ole.blue"
          "OvfGj2qjvkTzIfeKRXpA@ole.blue"
          "bestellung@ole.blue"
          "N1kAH4s3k3q6yxAiauVH@ole.blue"
          "ole@drogen.gratis"
          "6tvz1ov2vj2r5mtfvsvf@ole.blue"
          "2cgIIVYfX7Kk5Asx8awZ@ole.blue"
          "OTIqJBpXpka3lwiJLTsD@ole.blue"
          "BorJJYeqqlJbq5G6EQ9L@ole.blue"
          "tAKr6Lm0hNqTh9OELx4c@ole.blue"
          "euZvDRPCYpZe05KB2KVx@ole.blue"
          "ole@uwuwhatsthis.de"
          "w2ecnszqml8nakk171jz@uwuwhatsthis.de"
          "u0lz4wmhysa8v1omr8y7@uwuwhatsthis.de"
          "tm6vlpxedexvgrfcley6@uwuwhatsthis.de"
          "srgggi6tcywincl6gdn8@uwuwhatsthis.de"
          "pgjawyzwj2dmk9xao0zg@uwuwhatsthis.de"
          "olole@uwuwhatsthis.de"
          "ole+yh9arbin@uwuwhatsthis.de"
          "ole+r4lv87yk@uwuwhatsthis.de"
          "ole+nawlsprx@uwuwhatsthis.de"
          "ole+35vqwysr@uwuwhatsthis.de"
          "nd4hbdp05ygc2rl6bc99@uwuwhatsthis.de"
          "mu6mmbdfoik0ih63phzs@uwuwhatsthis.de"
          "lzssvwwtkwagqgaafzht@uwuwhatsthis.de"
          "lofntgxcyydzu2am3gtl@uwuwhatsthis.de"
          "kzaud9hj6dglf9spj7qd@uwuwhatsthis.de"
          "k90ycc513p8k8z402s7q@uwuwhatsthis.de"
          "g4yqny6acp2tmkqc9gv8@uwuwhatsthis.de"
          "fskmyzkclco5y5pzqjyt@uwuwhatsthis.de"
          "fbwp5nxatfsrx3qyo6fr@uwuwhatsthis.de"
          "f89z8z3m2ny4fa3ubleu@uwuwhatsthis.de"
          "f729315r1898b4n70873@uwuwhatsthis.de"
          "alias_easyabi@uwuwhatsthis.de"
          "4jsew3qe8vc8230b7nh7@uwuwhatsthis.de"
          "3lek2r3z8y3wpdvaymwr@uwuwhatsthis.de"
          "2d7g4yg7m168a692v4u9@uwuwhatsthis.de"
          "09mitjfrz0dlyhriyym9@uwuwhatsthis.de"
          "ysx3ul5jbqgqqprmatho@uwuwhatsthis.de"
          "xktumridfl7ehi0zr2nz@uwuwhatsthis.de"
          "xkssw87inle80jjd9lje@uwuwhatsthis.de"
          "sgjdlvefirpm9sx1hvad@uwuwhatsthis.de"
          "q6zdgo6sg0r1giuceezd@uwuwhatsthis.de"
          "pqrnnxsbuhjyvtbns25v@uwuwhatsthis.de"
          "l9nnzkupxtyrltfzqywm@uwuwhatsthis.de"
          "hzb6ggegr5tfiyhlnauj@uwuwhatsthis.de"
          "fkhdlwee9gtwvbahuj10@uwuwhatsthis.de"
          "dzmtfzgyrkz3ef6mit2e@uwuwhatsthis.de"
          "d9t65zbnj41j5puuagw4@uwuwhatsthis.de"
          "ce4ydvmxd81y5lpbq62k@uwuwhatsthis.de"
          "bljuz1db51uye3woxxv8@uwuwhatsthis.de"
          "alias_warframe_game@uwuwhatsthis.de"
          "alias_9anime@uwuwhatsthis.de"
          "ole@musicbot.info"
          "z2q5rvxoiecxsnhqapbjt8rzekxn9erqcgn8kxav@uwuwhatsthis.de"
          "ole@ole.blue"
          "6gkn8ve53vdfrxrlncxh@uwuwhatsthis.de"
          "fjkdlasjkfldsjkalf@uwuwhatsthis.de"
          "jfkldajklfjkasd@uwuwhatsthis.de"
          "fuckfuckfuck@uwuwhatsthis.de"
          "g6fjemjp4zjc9d3qa4qh@uwuwhatsthis.de"
          "zfu5ay3qbf9hvw0vwbxn@uwuwhatsthis.de"
          "dmn0s3gcf1ldr2cddlsr@uwuwhatsthis.de"
          "kzous3pgydjrf9qrso31@uwuwhatsthis.de"
          "test-123@uwuwhatsthis.de"
          "aciytslx2pvsprjpoggi@uwuwhatsthis.de"
          "cpd4evfm1se4sfjdxm8p@uwuwhatsthis.de"
          "y56xrwdwsodf7biwctyk@uwuwhatsthis.de"
          "wxpevphry5js5de7gpw5@uwuwhatsthis.de"
          "ocfy4qvtqlcgzein2sx4@uwuwhatsthis.de"
          "t7hobj8alpjdxmlqaff9@uwuwhatsthis.de"
          "pso8qzzwtzcytspbn2ye@uwuwhatsthis.de"
          "1cavbrdt@uwuwhatsthis.de"
          "koblmtkinjx5nenvxcvo@uwuwhatsthis.de"
          "postmaster@ole.blue"
          "postmaster@uwuwhatsthis.de"
          "abuse@ole.blue"
          "abuse@uwuwhatsthis.de"
          "roflrofl@ole.blue"
        ];
      };

      "scripts@uwuwhatsthis.de" = {
        hashedPasswordFile =
          "${config.age.secrets.scripts-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "sonarr@ole.blue" = {
        hashedPasswordFile =
          "${config.age.secrets.sonarr-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "prowlarr@uwuwhatsthis.de" = {
        hashedPasswordFile =
          "${config.age.secrets.prowlarr-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "uptime-kuma@ole.blue" = {
        hashedPasswordFile =
          "${config.age.secrets.uptime-kuma-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "firefly-iii@ole.blue" = {
        hashedPasswordFile = "${config.age.secrets.firefly-iii-ole-blue.path}";
        sendOnly = true;
      };

      "zed@ole.blue" = {
        hashedPasswordFile = "${config.age.secrets.zed-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "hydra@uwuwhatsthis.de" = {
        hashedPasswordFile = "${config.age.secrets.hydra-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "nextcloud@uwuwhatsthis.de" = {
        hashedPasswordFile =
          "${config.age.secrets.nextcloud-uwuwhatsthis-de.path}";
        sendOnly = true;
      };

      "nextcloud@ole.blue" = {
        hashedPasswordFile = config.age.secrets.nextcloud-ole-blue.path;
        sendOnly = true;
      };

      "forgejo@ole.blue" = {
        hashedPasswordFile = config.age.secrets.forgejo-email-ole-blue.path;
      };

      "auth@ole.blue" = {
        hashedPasswordFile = config.age.secrets.authelia-email-ole-blue.path;
      };

      "dmarc@ole.blue" = {
        hashedPasswordFile = config.age.secrets.dmarc-email-ole-blue.path;
        aliases = [ "dmarc@uwuwhatsthis.de" ];
      };

      "msmtp@ole.blue" = {
        hashedPasswordFile = config.age.secrets.msmtp-email-ole-blue.path;
        aliases = [ "smartd@ole.blue" ];
      };
    };

    certificateScheme = "acme-nginx";
  };

  services.roundcube = let
    # virtuser_file = pkgs.writeText "virtuser_file" ''
    #   ole@ole.blue roflrofl@ole.blue
    # '';
  in {
    enable = true;

    plugins = [
      # "managesieve"
      # "virtuser_file"
    ];

    hostName = "mail.ole.blue";
    extraConfig = ''
      $config['smtp_server'] = "tls://${config.mailserver.fqdn}";
      $config['smtp_user'] = "%u";
      $config['smtp_pass'] = "%p";

      $config['managesieve_port'] = '4190';
      $config['managesieve_host'] = '127.0.0.1';
      $config['managesieve_auth_type'] = 'PLAIN';
      $config['managesieve_usetls'] = false;

    '';
    # $config['virtuser_file'] = "${virtuser_file}";

    configureNginx = true;

    # database = {
    #   host = "loalhost";
    #   # host = "10.100.0.4";
    #   # passwordFile = config.age.secrets.postgresql-roundcube-password.path;
    #   # username = "roundcube";
    #   # dbname = "roundcube";
    # };
  };
}
