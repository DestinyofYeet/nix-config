{
  config,
  ...
}:

let 
  passbolt-dir = "${config.serviceSettings.paths.data}/passbolt";
in {

  age.secrets = {
    passbolt-env = { file = ../secrets/passbolt-env-file.age; };
  };

  virtualisation.oci-containers.containers = {

    passbolt = {
      image = "passbolt/passbolt";
      dependsOn = [ "pb-mariadb" ];

      # EMAIL_TRANSPORT_DEFAULT_PASSWORD
      environmentFiles = [
        "${config.age.secrets.passbolt-env.path}"
      ];
      
      # needs to be owned by uid 33
      volumes = [
        "${passbolt-dir}/passbolt/gpg:/etc/passbolt/gpg"
        "${passbolt-dir}/passbolt/jwt:/etc/passbolt/jwt"
      ];

      environment = {
        DATASOURCES_DEFAULT_PASSWORD = "passbolt";
        DATASOURCES_DEFAULT_HOST = "127.0.0.1";
        DATASOURCES_DEFAULT_USERNAME = "passbolt";
        DATASOURCES_DEFAULT_DATABASE = "passbolt";
        APP_FULL_BASE_URL = "https://passbolt.uwuwhatsthis.de";

        EMAIL_TRANSPORT_DEFAULT_HOST = "mx.uwuwhatsthis.de";
        EMAIL_TRANSPORT_DEFAULT_PORT = "587";
        EMAIL_TRANSPORT_DEFAULT_TLS = "true";
        EMAIL_DEFAULT_FROM = "passbolt@uwuwhatsthis.de";
        EMAIL_TRANSPORT_DEFAULT_USERNAME = "passbolt@uwuwhatsthis.de";
      };

      extraOptions = [
        "--network=container:pb-mariadb"
      ];
    };

    pb-mariadb = {
      image = "mariadb";

      ports = [
        "85:80"
        "445:443"
      ];

      volumes = [
        "${passbolt-dir}/mariadb:/var/lib/mysql"
      ];

      environment = {
        MARIADB_USER = "passbolt";
        MARIADB_PASSWORD = "passbolt";
        MARIADB_DATABASE = "passbolt";
        MARIADB_ROOT_PASSWORD = "root";
      };
    };
  };

  services.nginx.virtualHosts = {
    "passbolt.nix-server.infra.wg" = {
      listenAddresses = [
        "0.0.0.0"
      ];

      locations = {
        "/" = {
          proxyPass = "http://localhost:85";
        };
      };
    };
  };
}
