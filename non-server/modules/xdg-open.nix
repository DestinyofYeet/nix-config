{
  pkgs,
  ...
}:{
  xdg.mimeApps = rec {
    enable = true;
    associations.added = {
      "x-scheme-handler/bitwarden"     = [ "Bitwarden.desktop" ];
      "x-scheme-handler/sgnl"          = [ "signal-desktop.desktop" ];
      "x-scheme-handler/signalcaptcha" = [ "signal-desktop.desktop" ];
      "x-scheme-handler/https"         = [ "firefox.desktop" ];
      "x-scheme-handler/http"          = [ "firefox.desktop" ];
      "application/x-xopp" = [ "com.github.xournalpp.xournalpp.desktop" ];
      "application/pdf" = [ "org.kde.okular.desktop" ];
    };

    defaultApplications = associations.added;
  };
}
