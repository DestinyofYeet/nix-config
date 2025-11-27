{ keys }:
let
  authed = keys.authed
    ++ [ keys.systems.nix-server keys.systems.teapot keys.systems.bonk ];
in {
  "cloudflare-api-env.age".publicKeys = authed;

  "authentik-env.age".publicKeys = authed;
  "authentik-ldap-env.age".publicKeys = authed;
}
