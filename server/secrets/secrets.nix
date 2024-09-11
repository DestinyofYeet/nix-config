let
  system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPoi8INcA/HMRtCF9A3sIyfaCIYN0MOTWNg4IEe7zUO root@nixos";

  system_ole = 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcW4WZw7GhpHkuDBZVY3dpnUfm+8Ww+pyVWAMCB2BuB ole@nix-server";

  ole_laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";

  authed = [ system system_ole ole_laptop ];

in {
  "airvpn_config.age".publicKeys = authed;
  "hydra-email-credentials.age".publicKeys = authed;
  "nix-serve-priv-key.age".publicKeys = authed;
  "fireflyiii-appkey.age".publicKeys = authed;
  "scripts-email-pw.age".publicKeys = authed;
  "mysql-init-setup.age".publicKeys = authed;
  "mysql-passbolt-pw.age".publicKeys = authed;

  "ssh-github-nixos.age".publicKeys =  [ system_ole ];
}
