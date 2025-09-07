{ keys }:
let authed = keys.authed ++ [ keys.systems.teapot ];
in {
  "forgejo_email_password.age".publicKeys = authed;
  "forgejo_env_file.age".publicKeys = authed;

  "authelia-hashed-email-password.age".publicKeys = authed;
  "dmarc-hashed-email-password.age".publicKeys = authed;

  "mealie_env_file.age".publicKeys = authed;

  "msmtp-ole-blue.age".publicKeys = authed;

  "github-runners-strichliste-rs.age".publicKeys = authed;
}
