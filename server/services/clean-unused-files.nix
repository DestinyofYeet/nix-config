{ config, ... }:
let 
  secrets = config.serviceSettings.secrets; 
in {
  
  services.clean-unused-files = {
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

    inherit (config.serviceSettings) user group;
  };
}
