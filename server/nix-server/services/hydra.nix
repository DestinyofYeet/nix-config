{ config, stable-pkgs, ... }:{
  age.secrets = {
    hydra-email-credentials = { file = ../secrets/hydra-email-credentials.age; };
    hydra-github-credentials = {
      file = ../secrets/hydra-github-auth.age;
      owner = "hydra";
      group = "hydra";
      mode = "750";
    };
  };

  services.hydra = {
    enable = true;
    package = stable-pkgs.hydra_unstable;
    hydraURL = "http://nix-server.infra.wg:3000";
    notificationSender = "hydra@uwuwhatsthis.de";
    smtpHost = "mail.ole.blue";
    # buildMachinesFiles = [ "/etc/nix/machines" ];
    buildMachinesFiles = [];
    useSubstitutes = true;
    extraConfig = ''
      email_notification = 1

      Include ${config.age.secrets.hydra-github-credentials.path}

      <hydra_notify>
        <prometheus>
          listen_address = 127.0.0.1
          port = 9199
        </prometheus>
      </hydra_notify>
    '';
  };

  # nix.buildMachines = [
  #   {
  #     hostName = "localhost";
  #     protocol = null;
  #     system = "x86_64-linux";
  #     supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
  #     maxJobs = 8;    
  #   }
  # ];

  systemd.services.hydra-notify = {
    serviceConfig.EnvironmentFile = "${config.age.secrets.hydra-email-credentials.path}";
  };  

  nix.settings.allowed-uris = [
    "https://"
    "github:"
    "git+https://github.com/"
    "git+ssh://github.com/"
    "git+ssh://git@github.com/"
  ];

  services.nginx = let
    default-config = {
      locations."/" = {
        proxyPass = "http://localhost:3000";
        extraConfig = ''
          proxy_set_header        Accept-Encoding   "";
          proxy_set_header        Host            $host;
          proxy_set_header        X-Real-IP       $remote_addr;
          proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;

          ### Most PHP, Python, Rails, Java App can use this header ###
          #proxy_set_header X-Forwarded-Proto https;##
          #This is better##
          proxy_set_header        X-Forwarded-Proto $scheme;
          add_header              Front-End-Https   on;        
        '';
      };
    };
  in {
    virtualHosts = {
      "hydra.local.ole.blue" = config.serviceSettings.nginx-local-ssl // default-config;
    };
  };
}
