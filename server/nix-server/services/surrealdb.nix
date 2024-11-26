{ config, ... }:{
  
  services.surrealdb = {
    enable = false;
    host = "0.0.0.0";
    extraFlags = [
      "--auth"
      "--user"
      "root"
      "--pass"
      "${config.serviceSettings.secrets.surrealdb.root-pw}"
    ];
  };
}
