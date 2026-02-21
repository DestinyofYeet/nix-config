{
  config,
  pkgs,
  lib,
  ...
}:
{
  virtualisation.oci-containers.containers."firefly-iii-fints-importer" = {
    image = "benkl/firefly-iii-fints-importer";
    volumes = [
      "${
        lib.custom.settings.${config.networking.hostName}.paths.configs
      }/firefly-iii-fints-importer:/data/configurations"
    ];
    ports = [ "7070:8080" ];
  };

  systemd.services."import-firefly-data" = {
    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      output=$(${pkgs.curl}/bin/curl -X GET "http://localhost:7070/?automate=true&config=targobank.json")
      {
        echo "Subject: Imported Firefly-III data"
        echo $output
      } | ${pkgs.msmtp}/bin/msmtp -a firefly ole@ole.blue --set-to-header=on
    '';
  };

  systemd.timers."import-firefly-data" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 1:00:00";
      Unit = "import-firefly-data.service";
    };
  };

  services.nginx.virtualHosts."firefly-importer.local.ole.blue" =
    lib.custom.settings.${config.networking.hostName}.nginx-local-ssl
    // {
      locations."/" = {
        proxyPass = "http://localhost:7070";
      };
    };
}
