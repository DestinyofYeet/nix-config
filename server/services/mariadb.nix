{
  pkgs,
  config,
  ...
}:{
  age.secrets = {
    mysql-init = {
      file = ../secrets/mysql-init-setup.age;
      owner = "mysql";
    };
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  systemd.services.mysql.postStart = ''
    cat ${config.age.secrets.mysql-init.path} | ${config.services.mysql.package}/bin/mysql -N
  '';
}
