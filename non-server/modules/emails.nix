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

  accounts.email.accounts = rec {
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

    fachschaft_im = oth_stud_email // {
      primary = false;
      address = "fachschaft_im@oth-regensburg.de";

      # userName = "hs-regensburg.de\\beo45216";
      userName = "fachschaft_im@oth-regensburg.de";

      realName = "Fachschaft IM";
      signature = {
        showSignature = "append";
        text = ''
          ------------------------------------------------------------------------------------------
          Ostbayerische Technische Hochschule Regensburg
          Fachschaft Informatik Mathematik (FSIM)
          K-Gebäude K032
          Galgenbergstraße 32
          93053 Regensburg

          Telefon: +49 941 943 1276
          E-Mail: fachschaft_im@oth-regensburg.de
          Internet: https://www.fsim-ev.de/
          ---------------------------------------------------------------------------
        '';
      };
    };

    ole_blue = rec {
      address = "ole@ole.blue";
      thunderbird.enable = true;
      userName = "ole@ole.blue";
      realName = "Ole";
      imap = {
        host = "mail.ole.blue";
        tls = { enable = true; };
        port = 993;
      };

      smtp = {
        inherit (imap) host;
        tls.enable = true;
        port = 587;
      };

      aliases =
        flake.nixosConfigurations."teapot".config.mailserver.loginAccounts."ole@ole.blue".aliases;
    };
  };
}
