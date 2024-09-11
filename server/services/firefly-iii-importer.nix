{ config, pkgs, ... }:{
  virtualisation.oci-containers.containers."firefly-iii-fints-importer" = {
    image = "benkl/firefly-iii-fints-importer";
    volumes = [
      "${config.serviceSettings.paths.configs}/firefly-iii-fints-importer:/data/configurations" 
    ];
    ports = [
      "7070:8080"
    ];
  };

  systemd.services."import-firefly-data" = {
    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      ${pkgs.curl}/bin/curl -X GET "http://localhost:7070/?automate=true&config=targobank.json" 
      retval=$?
      if [ $retval -ne 0 ]; then
        content="Error importing data" 
      else
        content="Successfully imported data"
      fi

      ${config.serviceSettings.scripts.send-mail}/bin/send-mail --subject "Imported Firefly III data" --content $content --password-file ${config.age.secrets.send-email-pw.path}
    '';
  };

  systemd.timers."import-firefly-data" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "import-firefly-data.service";
    };
  };
}
