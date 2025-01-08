{
  config,
  stable-pkgs,
  ...
}:
{
  age.secrets = {
    hydra-email-credentials = {
      file = ../secrets/hydra-email-credentials.age;
    };
    hydra-github-credentials = {
      file = ../secrets/hydra-github-auth.age;
      # path = "/var/lib/hydra/github-auth";
      owner = "hydra";
      group = "hydra";
      mode = "750";
    };
  };

  services.hydra = {
    enable = true;
    # package = stable-pkgs.hydra;
    # needs to be http:// since hydra expects http for some reason
    hydraURL = "http://hydra.ole.blue";
    notificationSender = "hydra@uwuwhatsthis.de";
    smtpHost = "mail.ole.blue";
    listenHost = "127.0.0.1";
    # buildMachinesFiles = [ "/etc/nix/machines" ];
    buildMachinesFiles = [ ];
    useSubstitutes = true;
    extraConfig = ''
      email_notification = 1

      Include ${config.age.secrets.hydra-github-credentials.path}
    '';
  };

  systemd.services.hydra-notify = {
    serviceConfig.EnvironmentFile = "${config.age.secrets.hydra-email-credentials.path}";
  };

  nix.settings.allowed-uris = [
    "https://"
    "github:"
    "gitlab:"
    "git+https://github.com/"
    "git+https://gitlab.com/"
    "git+ssh://github.com/"
    "git+ssh://git@github.com/"
  ];

  services.nginx.virtualHosts."hydra.ole.blue" = {
    enableACME = true;
    forceSSL = true;

    locations."/" = {
      proxyPass = "http://localhost:3000";
      extraConfig = ''
        proxy_set_header  Host              $host;
        proxy_set_header  X-Real-IP         $remote_addr;
        proxy_set_header  X-Forwarded-For   $proxy_add_x_forwarded_for;

        # NO TOUCHEY
        add_header              Content-Security-Policy upgrade-insecure-requests;

        proxy_redirect     off;
      '';
    };
  };
}
