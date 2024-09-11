{ pkgs, ... }:{
  age.secrets = {
    send-email-pw = { file = ../secrets/scripts-email-pw.age; };
  };

  send-email = pkgs.writers.writePython3Bin "send-email" {
    flakeIgnore = [ "W291" "E305" "E501" "E111" "E302" ];
  } ./send-email.py;
}
