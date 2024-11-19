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
      output = $(${pkgs.curl}/bin/curl -X GET "http://localhost:7070/?automate=true&config=targobank.json")
      ${config.serviceScripts.send-email}/bin/send-email --subject "Imported Firefly III data" --content $output --password_file ${config.age.secrets.send-email-pw.path}
    '';
  };

  systemd.timers."import-firefly-data" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 1:00:00";
      Unit = "import-firefly-data.service";
    };
  };

  services.nginx.virtualHosts."firefly-importer.local.ole.blue" = config.serviceSettings.nginx-local-ssl // {
    locations."/" = {
      proxyPass = "http://localhost:7070";
    };
  };
}
