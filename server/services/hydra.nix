{ config, ... }:{
  age.secrets = {
    hydra-email-credentials = { file = ../secrets/hydra-email-credentials.age; };
  };

  services.hydra = {
    enable = true;
    hydraURL = "http://10.42.5.3:3000";
    notificationSender = "hydra@uwuwhatsthis.de";
    smtpHost = "mx.uwuwhatsthis.de";
    buildMachinesFiles = [];
    useSubstitutes = true;
    extraConfig = ''
      email_notification = 1
      allowed-uris = https://github.com/*
    '';
  };

  systemd.services.hydra-notify = {
    serviceConfig.EnvironmentFile = "${config.age.secrets.hydra-email-credentials.path}";
  };  
}
