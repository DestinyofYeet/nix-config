{
  config,
  ...
}:{
  virtualisation.oci-containers.containers = {

    passbolt = {
      image = "passbolt/passbolt";
      dependsOn = [ "pb-mariadb" ];

      environment = {
        DATASOURCES_DEFAULT_PASSWORD = "passbolt";
        DATASOURCES_DEFAULT_HOST = "127.0.0.1";
        DATASOURCES_DEFAULT_USERNAME = "passbolt";
        DATASOURCES_DEFAULT_DATABASE = "passbolt";
        APP_FULL_BASE_URL = "http://passbolt.nix-server.infra.wg";
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
