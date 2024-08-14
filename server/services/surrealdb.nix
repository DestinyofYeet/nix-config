{ config, ... }:{
  
  age.secrets = {
    surrealdb-root-pw = { file  = ../secrets/surrealdb_root_pw.age; };
  };

  services.surrealdb = {
    enable = true;
    host = "0.0.0.0";
    extraFlags = [
      "--auth"
      "--user"
      "root"
      "--pass"
      "${builtins.readFile config.age.secrets.surrealdb-root-pw.path}"
    ];
  };
}
