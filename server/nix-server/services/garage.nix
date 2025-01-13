{
  config,
  lib,
  pkgs,
  ...
}:
let
  apiPort = 3900;
  rpcPort = 3901;
  webPort = 3902;
  adminPort = 3903;
in
{
  age.secrets = {
    garage-rpc-secret.file = ../secrets/garage-rpc-secret.age;
    garage-admin-token.file = ../secrets/garage-admin-token.age;
  };

  services.garage = {
    enable = true;

    package = pkgs.garage_1_x;

    # extraEnvironment = {
    #   "GARAGE_RPC_SECRET_FILE" = config.age.secrets.garage-rpc-secret.path;
    #   "GARAGE_ADMIN_TOKEN_FILE" = config.age.secrets.garage-admin-token.path;
    # };

    settings = {
      data_dir = "/mnt/data/data/garage";

      db_engine = "sqlite";

      replication_factor = 1;

      rpc_bind_addr = "[::]:${toString rpcPort}";
      rpc_public_addr = "127.0.0.1:${toString rpcPort}";

      s3_api = {
        api_bind_addr = "127.0.0.1:${toString apiPort}";
        s3_region = "eu-de-south-1";
        root_domain = "s3.local.ole.blue";
      };

      s3_web = {
        bind_addr = "127.0.0.1:${toString webPort}";
        root_domain = "s3-web.local.ole.blue";
      };

      admin = {
        api_bind_addr = "127.0.0.1:${toString adminPort}";
      };
    };
  };

  users = {
    groups.garage = { };
    users.garage = {
      group = "garage";
      isSystemUser = true;
    };
  };

  systemd.services.garage.serviceConfig = lib.mkIf config.services.garage.enable {
    User = "garage";

    ReadWriteDirectories = [ config.services.garage.settings.data_dir ];

    LoadCredential = [
      "rpc_secret_path:${config.age.secrets.garage-rpc-secret.path}"
      "admin_token_path:${config.age.secrets.garage-admin-token.path}"
    ];
    Environment = [
      "GARAGE_ALLOW_WORLD_READABLE_SECRETS=true"
      "GARAGE_RPC_SECRET_FILE=%d/rpc_secret_path"
      "GARAGE_ADMIN_TOKEN_FILE=%d/admin_token_path"
    ];
  };

  systemd.tmpfiles.rules = lib.mkIf config.services.garage.enable [
    "A+ ${config.services.garage.settings.data_dir} - - - - user:${config.systemd.services.garage.serviceConfig.User}:rwx"
  ];

  services.nginx.virtualHosts =
    let
      ssl-conf = lib.custom.settings.${config.networking.hostName}.nginx-local-ssl;
    in
    {

      "${config.services.garage.settings.s3_api.root_domain}" = ssl-conf // {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString apiPort}";
          extraConfig = ''
            proxy_max_temp_file_size 0;
            client_max_body_size 5G;
          '';
        };
      };

      "${config.services.garage.settings.s3_web.root_domain}" = ssl-conf // {
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString webPort}";
        };
      };
    };

  programs.bash.shellAliases = {
    garage = "${config.services.garage.package}/bin/garage --rpc-secret-file ${config.age.secrets.garage-rpc-secret.path}";
  };
}
