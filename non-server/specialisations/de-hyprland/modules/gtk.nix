{
  ...
}:
{
  gtk = rec {
    gtk2.extraConfig = ''
      gtk-im-module="fcitx"
    '';

    gtk3.extraConfig = {
      gtk-im-module = "fcitx";
    };

    # gtk3.extraConfig = ''
    #   [Settings]
    #   gtk-im-module=fcitx
    # '';

    gtk4.extraConfig = gtk3.extraConfig;
  };
}
