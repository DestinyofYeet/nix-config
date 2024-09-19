{
  config,
  ...
}:{
  home.file = {
    ".config/mutt/muttrc" = {
      text = ''
        set from=ole.bendixen@st.oth-regensburg.de
        set imap_user='ole.bendixen@st.oth-regensburg.de'

        set realname="Ole Bendixen"

        set editor="${config.customSettings.currentEditor}"
      '';
    };
  };
}
