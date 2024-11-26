{
  config,
  pkgs,
  ...
}:let

  upssched-cmd = pkgs.writeShellScriptBin "upssched-cmd" ''
    case $1 in 
      onbattwarn)
        shutdown -h now
          ;;
      ups-back-on-power)
        shutdown -c
          ;;
    esac
  '';

  upssched-conf = pkgs.writeText "upssched.conf" ''
    CMDSCRIPT ${upssched-cmd}/bin/upssched-cmd

    PIPEFN /etc/nut/upssched.pipe
    LOCKFN /etc/nut/upssched.lock

    AT ONBATT * START-TIMER onbattwarn 240
    AT ONLINE * CANCEL-TIMER onbattwarn
    AT ONLINE * EXECUTE ups-back-on-power
  '';
in {

  age.secrets = {
    password-file = { file = ../secrets/upsmon-password-file.age; };
  };

  power.ups = {
    enable = true;

    ups = {
      riello = {
        port = "auto";
        driver = "riello_usb";
      };
    };

    schedulerRules = builtins.toString upssched-conf;

    upsmon = {
      settings = {
        MINSUPPLIES = 1;

        SHUTDOWNCMD = "/run/current-system/sw/bin/shutdown -h 1";

        NOTIFYFLAG = [ [ "ONLINE" "SYSLOG+EXEC" ] [ "ONBATT" "SYSLOG+EXEC"]];

        SHUTDOWNEXIT = true;
      };

      monitor = {
        riello = {
          powerValue = 1;
          user = "ole";
          passwordFile = config.age.secrets.password-file.path;
        };
      };
    };
  };
}
