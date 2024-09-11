{ pkgs, lib, ... }:{

  config.age.secrets = {
    send-email-pw = { file = ../secrets/scripts-email-pw.age; };
  };

  options.serviceScripts = with lib; {
    send-email = mkOption {
      type = types.package;
    };
  };

  config.serviceScripts = {
    send-email = pkgs.writers.writePython3Bin "send-email" {
      flakeIgnore = [ "W291" "E305" "E501" "E111" "E302" ];
    } ./send-email.py;
  };
}
