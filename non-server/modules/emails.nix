{
  config,
  pkgs,
  ...
}:{
  age.secrets = {
    oth-regensburg-email-pw.file = ../secrets/oth-regensburg-email-pw.age;
  };

  accounts.email.accounts = {
    oth-stud-email = rec {
      primary = true;
      address = "ole.bendixen@st.oth-regensburg.de";
 
      userName = "hs-regensburg.de\\beo45216";

      imap = {
        host = "exchange.hs-regensburg.de";
        port = 993;
        tls = {
          enable = true;
          useStartTls = false;
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
    };
  };
}
