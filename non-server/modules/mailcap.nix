{
  pkgs,
  inputs,
  ...
}:{
  home.file.".mailcap".text = ''
    text/html; ${pkgs.lynx}/bin/lynx '%s';i description=HTML Text; nametemplate=%s.html

    application/pdf; ${pkgs.kdePackages.okular}/bin/okular '%s';

    text/calendar; ${inputs.prpr-muttkalendar.packages.x86_64-linux.default}/bin/ics_muttkalender -c %{charset} -i '%s'; copiousoutput
  '';
}
