{ keys, functions, ... }@inputs:
let
  authed = keys.authed ++ [ keys.hosts.teapot.hostKey ];
  importFolder = functions.getImportFolder ./.;
in
{
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

  "matrix-registration-token.age".publicKeys = authed;
  "matrix-turn-secret.age".publicKeys = authed;
  "matrix-oauth_client_secret.age".publicKeys = authed;

  "nix-serve-priv-key.age".publicKeys = authed;

  "ole-ole.blue.age".publicKeys = authed;
  "scripts-uwuwhatsthis.de.age".publicKeys = authed;
  "sonarr-uwuwhatsthis.de.age".publicKeys = authed;
  "prowlarr-uwuwhatsthis.de.age".publicKeys = authed;
  "uptime-kuma-uwuwhatsthis.de.age".publicKeys = authed;
  "zed-uwuwhatsthis.de.age".publicKeys = authed;
  "nextcloud-ole-blue.age".publicKeys = authed;

  "wireguard-vpn-priv-key.age".publicKeys = authed;

}
// (importFolder "vms/" inputs)
