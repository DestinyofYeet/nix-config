let
  system = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPoi8INcA/HMRtCF9A3sIyfaCIYN0MOTWNg4IEe7zUO root@nixos";

  system_ole = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcW4WZw7GhpHkuDBZVY3dpnUfm+8Ww+pyVWAMCB2BuB ole@nix-server";

  ole_laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";

  ole_main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC+o4K+CbcAYSGz+8KWqsm3r878EK2wDSHplFbULwQv ole@main";

  authed = [
    system
    system_ole
    ole_laptop
    ole_main
  ];

in
{
  "airvpn_config.age".publicKeys = authed;
  "hydra-email-credentials.age".publicKeys = authed;
  "nix-serve-priv-key.age".publicKeys = authed;
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

  "ssh-github-nixos.age".publicKeys = [ system_ole ];

  "qbit-prometheus-exporter.age".publicKeys = authed;

  "deluge-password-file.age".publicKeys = authed;

  "hydra-github-auth.age".publicKeys = authed;

  "paperless-ngx-admin.age".publicKeys = authed;

  "firefly-email-credentials.age".publicKeys = authed;

  "email-uptime-kuma.age".publicKeys = authed;
}
