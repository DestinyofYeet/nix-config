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
  "authelia-ole-blue-email-pw.age".publicKeys = authed;

  "authelia-openid-jellyfin-id.age".publicKeys = authed;
  "authelia-openid-jellyfin-key.age".publicKeys = authed;

  "authelia-openid-forgejo-id.age".publicKeys = authed;
  "authelia-openid-forgejo-key.age".publicKeys = authed;

  "authelia-openid-nextcloud-id.age".publicKeys = authed;
  "authelia-openid-nextcloud-key.age".publicKeys = authed;

  "authelia-openid-paperless-id.age".publicKeys = authed;
  "authelia-openid-paperless-key.age".publicKeys = authed;

  "authelia-openid-immich-id.age".publicKeys = authed;
  "authelia-openid-immich-key.age".publicKeys = authed;

  "authelia-openid-wikijs-id.age".publicKeys = authed;
  "authelia-openid-wikijs-key.age".publicKeys = authed;

  "authelia-openid-mealie-id.age".publicKeys = authed;
  "authelia-openid-mealie-key.age".publicKeys = authed;
}
