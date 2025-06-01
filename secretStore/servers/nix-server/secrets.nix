{ keys }:
let
  system_ole =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcW4WZw7GhpHkuDBZVY3dpnUfm+8Ww+pyVWAMCB2BuB ole@nix-server";

  authed = keys.authed ++ [ keys.systems.nix-server ];
in {
  "airvpn_config.age".publicKeys = authed;
  "hydra-email-credentials.age".publicKeys = authed;
  "fireflyiii-appkey.age".publicKeys = authed;
  "scripts-email-pw.age".publicKeys = authed;
  "mysql-init-setup.age".publicKeys = authed;
  "mysql-passbolt-pw.age".publicKeys = authed;
  "passbolt-env-file.age".publicKeys = authed;
  "upsmon-password-file.age".publicKeys = authed;
  "zed-email-credentials.age".publicKeys = authed;

  "ankisync-users-ole.age".publicKeys = authed;

  "cloudflare-api-env.age".publicKeys = authed;

  "airvpn-deluge.age".publicKeys = authed;

  "auto-add-torrents.conf.age".publicKeys = authed;

  "qbit-prometheus-exporter.age".publicKeys = authed;

  "deluge-password-file.age".publicKeys = authed;

  "hydra-github-auth.age".publicKeys = authed;

  "paperless-ngx-admin.age".publicKeys = authed;

  "firefly-email-credentials.age".publicKeys = authed;

  "email-uptime-kuma.age".publicKeys = authed;

  "wireguard-vpn-priv-key.age".publicKeys = authed;

  "garage-rpc-secret.age".publicKeys = authed;
  "garage-admin-token.age".publicKeys = authed;

  "nextcloud-bucket-secret-key.age".publicKeys = authed;
  "nextcloud-admin-pass.age".publicKeys = authed;

  "postgresql-init.age".publicKeys = authed;

  "lldap-jwt-secret.age".publicKeys = authed;
  "lldap-key-seed.age".publicKeys = authed;
  "lldap-user-pass.age".publicKeys = authed;

  "paperless-authelia-env-file.age".publicKeys = authed;

  "dmarc-ole-blue-password.age".publicKeys = authed;

  "maxmind-license-key.age".publicKeys = authed;

  "msmtp-ole-blue.age".publicKeys = authed;

  "restic-repo-configs.age".publicKeys = authed;
  "restic-repo-configs-pw.age".publicKeys = authed;

  "restic-repo-photos.age".publicKeys = authed;
  "restic-repo-photos-pw.age".publicKeys = authed;

  "kavita-tokenkey.age".publicKeys = authed;

  "photoprism-admin.age".publicKeys = authed;
}
