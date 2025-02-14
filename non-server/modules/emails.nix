{
  config,
  pkgs,
  secretStore,
  ...
}: {
  age.secrets = {
    oth-regensburg-email-pw.file = secretStore.secrets + /non-server/oth-regensburg-email-pw.age;
    email-uwuwhatsthis-pw.file = secretStore.secrets + /non-server/email-uwuwhatsthis-pw.age;
  };

  programs = {
    mbsync.enable = true;
    msmtp.enable = true;
    notmuch = {
      enable = true;
      hooks = {
        preNew = "mbsync --all";
      };
    };
  };

  accounts.email.accounts = {
    oth-stud-email = rec {
      primary = true;
      address = "ole.bendixen@st.oth-regensburg.de";

      # userName = "hs-regensburg.de\\beo45216";
      userName = "beo45216@hs-regensburg.de";

      msmtp.enable = true;

      mbsync = {
        enable = true;
        create = "maildir";
      };

      notmuch.enable = true;

      imap = {
        host = "exchange.hs-regensburg.de";
        tls = {
          enable = true;
        };
      };

      smtp = {
        inherit (imap) host;
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      passwordCommand = "cat ${config.age.secrets.oth-regensburg-email-pw.path}";

      realName = "Ole Bendixen";

      neomutt = {
        enable = true;
        mailboxType = "imap";
      };

      folders = {
        sent = "Sent Items";
        trash = "Deleted Items";
      };

      signature = {
        showSignature = "append";
        text = ''
          ------------------------------------------------------------------------------------------
          Ostbayerische Technische Hochschule Regensburg
          Fakultät Informatik und Mathematik (IM)
          Galgenbergstr. 32
          93053 Regensburg

          Fachschaftssprecher / Studierendenvertreter
          Ole Bendixen
          Telefon: +49 941 943 1276
          E-Mail: ole.bendixen@st.oth-regensburg.de
          Internet: https://www.fsim-ev.de/
          ---------------------------------------------------------------------------
        '';
      };
    };

    uwuwhatsthis = rec {
      # primary = true;
      address = "ole@uwuwhatsthis.de";
      userName = "ole";
      msmtp.enable = true;
      mbsync = {
        enable = true;
        create = "maildir";
      };
      notmuch.enable = true;

      imap = {
        host = "mx.uwuwhatsthis.de";
        tls = {
          enable = true;
        };
      };
      smtp = {
        inherit (imap) host;
        tls = {
          enable = true;
        };
      };

      passwordCommand = "cat ${config.age.secrets.email-uwuwhatsthis-pw.path}";

      realName = "ole";
      neomutt = {
        enable = true;
        mailboxType = "imap";
      };
    };
  };
}
