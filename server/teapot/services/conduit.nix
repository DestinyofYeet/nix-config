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

    sliding-sync-secret.file = ../secrets/sliding-sync-secret.age;
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
      };
    };
  };

  virtualisation.oci-containers.containers = {
    syncv3-pg = {
      image = "postgres:13";

      volumes = [
        "/var/lib/syncv3/pg:/var/lib/postgresql"
      ];

      environment = {
        POSTGRES_USER = "syncv3";
        POSTGRES_PASSWORD = "syncv3";
        POSTGRES_DB = "syncv3";
      };

      ports = [
        "8001:8008"
      ];
    };

    syncv3 = {
      image = "ghcr.io/matrix-org/sliding-sync:latest";

      dependsOn = [
        "syncv3-pg"
      ];

      environment = {
        SYNCV3_SERVER = "https://matrix.ole.blue";
        SYNCV3_DB = "user=syncv3 dbname=syncv3 sslmode=disable host=127.0.0.1 password=syncv3";
        SYNCV3_BINDADDR = "0.0.0.0:8008";

        SYNCV3_LOG_LEVEL = "trace";
      };

      environmentFiles = [
        config.age.secrets.sliding-sync-secret.path
      ];

      extraOptions = [ "--network=container:syncv3-pg" ];
    };
  };

  services.nginx.virtualHosts = {
    "matrix.ole.blue" = {
      enableACME = true;
      forceSSL = true;

      extraConfig = ''
        location ~ ^(\/_matrix|\/_synapse\/client) {
            proxy_pass http://${config.services.matrix-conduit.settings.global.address}:${toString config.services.matrix-conduit.settings.global.port};
            proxy_set_header X-Forwarded-For $remote_addr;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header Host $host;
        }

        location /.well-known/matrix/client {
          add_header Content-Type application/json;
          add_header Access-Control-Allow-Origin '*';
          return 200 '{ "m.homeserver": { "base_url": "https://matrix.ole.blue" }, "org.matrix.msc3575.proxy": {"url":"https://sync.matrix.ole.blue" }}';
        }
      '';
    };

    "sync.matrix.ole.blue" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://localhost:8001";
      };
    };
  };
}
