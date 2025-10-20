{ config, pkgs, secretStore, flake, ... }: {
  age.secrets = {
    oth-regensburg-email-pw.file = secretStore.secrets
      + /non-server/oth-regensburg-email-pw.age;
    email-ole-blue-pw.file = secretStore.secrets
      + /non-server/email-ole-blue-pw.age;
  };

  programs = {
    thunderbird = {
      enable = true;
      profiles = {
        "default" = {
          isDefault = true;
          accountsOrder = [ "oth_stud_email" "fachschaft_im" "ole_blue" ];
        };
      };

      settings = {
        # default use body-text instead of paragraph when writing an e-mail
        "mail.compose.default_to_paragraph" = false;
      };
    };

  };

  accounts.email.accounts = {
    oth_stud_email = {
      primary = true;
      address = "ole.bendixen@st.oth-regensburg.de";

      flavor = "outlook.office365.com";

      thunderbird = {
        enable = true;

        settings = id: {
          # sets method to oauth2
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };

      # userName = "hs-regensburg.de\\beo45216";
      userName = "beo45216@hs-regensburg.de";

      imap = {
        host = "outlook.office365.com";
        port = 993;
        tls = { enable = true; };
      };

      smtp = {
        host = "smtp.office365.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      realName = "Ole Bendixen";
      signature = {
        showSignature = "append";
        text = ''
          --------------------------------------------------------------------------
          Ostbayerische Technische Hochschule Regensburg
          Fakultät Informatik und Mathematik (IM)
          Galgenbergstr. 32
          93053 Regensburg

          Fachschaftssprecher / Studierendenvertreter
          Ole Bendixen
          Telefon: +49 941 943 1276
          E-Mail: ole.bendixen@st.oth-regensburg.de
          Internet: https://www.fsim-ev.de/
          --------------------------------------------------------------------------
        '';
      };
    };

    ole_hotmail = {
      thunderbird = {
        enable = true;

        settings = id: {
          # sets method to oauth2
          "mail.server.server_${id}.authMethod" = 10;
          "mail.smtpserver.smtp_${id}.authMethod" = 10;
        };
      };

      address = "bendiixeno@hotmail.de";
      userName = "bendiixeno@hotmail.de";
      realName = "Ole";

      imap = {
        host = "outlook.office365.com";
        port = 993;
        tls = { enable = true; };
      };

      smtp = {
        host = "smtp-mail.outlook.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
    };

    ole_gmail = {
      flavor = "gmail.com";
      address = "olebend@gmail.com";
      thunderbird.enable = true;
      userName = "olebend@gmail.com";
      realName = "Ole";

      imap = {
        host = "imap.gmail.com";
        tls.enable = true;
        port = 993;
      };

      smtp = {
        host = "smtp.gmail.com";
        tls.enable = true;
        port = 465;
      };
    };

    ole_blue = rec {
      address = "ole@ole.blue";
      thunderbird.enable = true;
      userName = "ole@ole.blue";
      realName = "Ole";
      passwordCommand = "cat ${config.age.secrets.email-ole-blue-pw.path}";
      imap = {
        host = "mail.ole.blue";
        tls = { enable = true; };
        authentication = "plain";
        port = 993;
      };

      smtp = {
        inherit (imap) host;
        tls.enable = true;
        authentication = "plain";
        port = 465;
      };

      aliases =
        flake.nixosConfigurations."teapot".config.mailserver.loginAccounts."ole@ole.blue".aliases;
    };
  };
}
