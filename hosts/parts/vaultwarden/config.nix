{
  config,
  secretStore,
  pkgs,
  ...
}:
let
  secrets = secretStore.getServerSecrets "common";

  machines = import ../../../custom/nebula/machines.nix;
in
{
  age.secrets =
    let
      ownership = {
        owner = "vaultwarden";
        group = "vaultwarden";
      };
    in
    {
      vaultwarden-env.file = secrets + "/vaultwarden-env.age";
      vaultwarden-private-key = {
        file = secrets + "/vaultwarden-private-key.age";
        path = "/var/lib/bitwarden_rs/key.pem";
      }
      // ownership;
    };

  imports = [
    ./cert.nix
  ];

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";

    domain = "vault.ole.blue";

    environmentFile = config.age.secrets.vaultwarden-env.path;

    config = rec {
      ROCKET_ADDRESS = "${machines.${config.networking.hostName}.ip}";
      ROCKET_PORT = 7462;

      DATA_DIR = "/var/lib/bitwarden_rs/data";
      ATTACHMENTS_FOLDER = "${DATA_DIR}/attachments";
      SENDS_FOLDER = "${DATA_DIR}/sends";
      ICON_CACHE = "${DATA_DIR}/icon_cache";

      RSA_KEY_FILENAME = "/var/lib/bitwarden_rs/key";

      SSO_ENABLED = true;
      SSO_AUTHORITY = "https://idp.ole.blue/application/o/vaultwarden/";
      SSO_SCOPES = "email profile offline_access";
      SSO_ALLOW_UNKNOWN_EMAIL_VERIFICATION = false;
      SSO_CLIENT_CACHE_EXPIRATION = 0;
      SSO_SIGNUPS_MATCH_EMAIL = true;

      SMTP_HOST = "mail.ole.blue";
      SMTP_FROM = "vaultwarden@ole.blue";
      SMTP_FROM_NAME = "Vaultwarden";
      SMTP_USERNAME = " vaultwarden@ole.blue";
      SMTP_SECURITY = "force_tls";
    };
  };

  users.users = {
    vaultwarden = {
      shell = pkgs.bashInteractive;
      openssh.authorizedKeys.keys = [
        ''command="${pkgs.rrsync}/bin/rrsync ${config.services.vaultwarden.config.DATA_DIR}",restrict ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPOvqamLyP84oIeA4PTty4arxsPeWyzCWB46UQ7n4R+O''
      ];
    };
  };
}
