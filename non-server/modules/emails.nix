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
      profiles = { "default" = { isDefault = true; }; };
    };
  };

  accounts.email.accounts = {
    oth-stud-email = {
      primary = true;
      address = "ole.bendixen@st.oth-regensburg.de";

      thunderbird = {
        enable = true;

        settings = id: {
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

    ole-blue = rec {
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
