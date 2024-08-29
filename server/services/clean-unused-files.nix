{ config, ... }:
let 
  secrets = config.serviceSettings.secrets; 
in {
  
  services.cleanUnusedFiles = {
    enable = true;

    qbit = {
      url = "http://10.1.1.1:8080";
      user = secrets.qbit.user;
      password = secrets.qbit.pw;
    };

    email = {
      inherit (secrets.email) server user password;
      recipient = "ole@uwuwhatsthis.de";
    };

    dataFile = "/data/programs/clean_unused_files/data.json";

    timerConfig = {
      OnCalendar = "weekly";
    };

    inherit (config.serviceSettings) user group;
  };
}
