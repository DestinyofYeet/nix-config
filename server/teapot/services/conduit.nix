{
  config,
  ...
}:
{

  imports = [
    ./conduit_service_patch.nix
  ];

  age.secrets = {
    conduit-env-file.file = ../secrets/conduit-env-file.age;
  };

  services.matrix-conduit = {
    enable = true;

    settings = {
      global = {

        address = "127.0.0.1";
        port = 8000;

        server_name = "matrix.ole.blue";

        backend = "rocksdb";

        enable_lightning_bolt = false;

        allow_registration = true;

        allow_federation = true;

        trusted_servers = [
          "matrix.org"
          "vector.im"
        ];

        well_known = {
          client = "https://matrix.ole.blue";
          server = "matrix.ole.blue:443";
        };
      };
    };
  };

  services.nginx.virtualHosts = {
    "matrix.ole.blue" = {
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        location / {
            proxy_pass http://${config.services.matrix-conduit.settings.global.address}:${toString config.services.matrix-conduit.settings.global.port};
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
        }
      '';
    };
  };
}
