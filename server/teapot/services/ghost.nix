{
  ...
}:{
  virtualisation.oci-containers.containers = {
    "ghost-server" = {
      image = "ghost:5.101.4";

      environment = {
        database__client = "mysql";
        database__connection__host = "127.0.0.1";
        database__connection__user = "ghost";
        database__connection__password = "ghost";
        database__connection__database = "ghost";

        url = "https://ole.blue";
      };

      dependsOn = [
        "ghost-db"
      ];

      extraOptions = [
        "--network=container:ghost-db"
      ];

      volumes = [
        "/var/lib/ghost/content:/var/lib/ghost/content"
      ];
    };

    "ghost-db" = {
      image = "mysql:9.1.0";

      ports = [
        "2368:2368"
      ];

      environment = {
        "MYSQL_HOST" = "127.0.0.1";
        "MYSQL_RANDOM_ROOT_PASSWORD" = "yes";
        "MYSQL_USER" = "ghost";
        "MYSQL_PASSWORD" = "ghost";
        "MYSQL_DATABASE" = "ghost";
      };

      volumes = [
        "/var/lib/ghost/db:/var/lib/mysql"
      ];
    };
  };

  services.nginx.virtualHosts."ole.blue" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:2368";
      extraConfig = ''
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $host;
      '';
    };
  };
}
