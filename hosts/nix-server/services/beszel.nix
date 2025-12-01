{ lib, config, ... }:
let beszel_config = config.services.beszel_hub;
in {
  services.beszel_hub = {
    enable = true;
    port = 8091;
  };

  services.beszel_agent = {
    enable = true;
    port = 45876;
    publicKey =
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEynJeSmkCHA7bHfmbFZxZbP0W2vxcGp7Vi4EKp5x0TY";
    disks = [
      "/dev/sdd"
      "/dev/sda"
      "/dev/sdc"
      "/dev/sde"
      "/dev/sdf"
      "/dev/sdg"
      "/dev/sdh"
      "/dev/sdi"
      "/dev/nvme0n1"
      "/mnt/data/data/media"
      "/mnt/data/data/photos/handy"
      "/mnt/data/data/photos/macbook"
      "/mnt/data/data/paperless-ngx"
    ];
  };

  services.nginx.virtualHosts = let
    defaultConfig = {
      locations."/" = {
        proxyPass =
          "http://${beszel_config.host}:${toString beszel_config.port}";
        proxyWebsockets = true;
        extraConfig = ''
              proxy_set_header Host $host;
          		proxy_set_header X-Real-IP $remote_addr;
          		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          		proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };
  in {
    "data.local.ole.blue" = lib.custom.settings.nix-server.nginx-local-ssl
      // defaultConfig;
  };

}
