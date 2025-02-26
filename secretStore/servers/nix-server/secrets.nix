{ keys }:
let
  system_ole = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcW4WZw7GhpHkuDBZVY3dpnUfm+8Ww+pyVWAMCB2BuB ole@nix-server";

  authed = keys.authed ++ [
    keys.systems.nix-server
  ];
in
{
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
}
