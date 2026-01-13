{ keys, functions, ... }@inputs:
let
  authed = keys.authed ++ [ keys.hosts.teapot.hostKey ];
  importFolder = functions.getImportFolder ./.;
in {
  "forgejo_email_password.age".publicKeys = authed;
  "forgejo_env_file.age".publicKeys = authed;

  "authelia-hashed-email-password.age".publicKeys = authed;
  "dmarc-hashed-email-password.age".publicKeys = authed;

  "mealie_env_file.age".publicKeys = authed;

  "msmtp-ole-blue.age".publicKeys = authed;

  "github-runners-strichliste-rs.age".publicKeys = authed;

  "rspamd-domain-whitelist.age".publicKeys = authed;

  "mastodon_email_password_hash.age".publicKeys = authed;
  "mastodon_email_password.age".publicKeys = authed;

  "authentik_email_password_hash.age".publicKeys = authed;

  "vm-ha-hostkey-ed25519.age".publicKeys = authed;
  "vm-ha-hostkey-rsa.age".publicKeys = authed;
} // (importFolder "vms/" inputs)
