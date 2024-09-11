{
  config,
  ...
}:{

  age.secrets = {
    mysql-passbolt-pw = { file = ../secrets/mysql-passbolt-pw.age; };
  };

  virtualisation.oci-containers.containers.passbolt = {
    image = "passbolt/passbolt";
    ports = [
      "85:80"
      "445:443"
    ];

    environment = {
      DATASOURCES_DEFAULT_PASSWORD_FILE = config.age.secrets.mysql-passbolt-pw.path;
      DATASOURCES_DEFAULT_HOST = "localhost";
      DATASOURCES_DEFAULT_USERNAME = "passbolt";
      DATASOURCES_DEFAULT_DATABASE = "passbolt";
    };
  };
}
