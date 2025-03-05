{ keys }:
let authed = keys.authed ++ [ keys.systems.teapot ];
in {
  "forgejo_email_password.age".publicKeys = authed;
  "forgejo_env_file.age".publicKeys = authed;
}
