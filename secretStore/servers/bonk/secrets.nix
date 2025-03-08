{ keys }:
let authed = keys.authed ++ [ keys.systems.bonk ];
in {
  "nextcloud-root-pw.age".publicKeys = authed;

  "authelia-lldap-pw.age".publicKeys = authed;
  "authelia-jwt.age".publicKeys = authed;
  "authelia-oidc-hmac-secret.age".publicKeys = authed;
  "authelia-oidc-private-key.age".publicKeys = authed;
  "authelia-session-secret.age".publicKeys = authed;
  "authelia-storage-encryption-keys.age".publicKeys = authed;

  "authelia-openid-jellyfin-id.age".publicKeys = authed;
  "authelia-openid-jellyfin-key.age".publicKeys = authed;
}
