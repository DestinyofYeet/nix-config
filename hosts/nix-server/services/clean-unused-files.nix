{ config, lib, ... }:
let
  secrets = lib.custom.settings.${config.networking.hostName}.secrets;
in
{

  services.cleanUnusedFiles = {
    enable = false;

    qbit = {
      url = "http://10.1.1.1:8080";
      user = secrets.qbit.user;
      password = secrets.qbit.pw;
    };

    email = {
      inherit (secrets.email) server user password;
      recipient = "ole@uwuwhatsthis.de";
    };

    dataFile = "${
      lib.custom.settings.${config.networking.hostName}.paths.data
    }/programs/clean_unused_files/data.json";

    timerConfig = {
      OnCalendar = "weekly";
    };

    inherit (lib.custom.settings.${config.networking.hostName}) user group;
  };
}
