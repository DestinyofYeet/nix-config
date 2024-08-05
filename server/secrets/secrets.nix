let
  system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPoi8INcA/HMRtCF9A3sIyfaCIYN0MOTWNg4IEe7zUO root@nixos";

  ole_laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";
  ole_main =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDhLrbWc/gopTJ2ZZW4ZfCzGhjhV9fKb1wdvFLQpmP3y ole@main";

  ole = [ ole_laptop ole_main ];

  authed = [ system ] ++ ole;

in {
  "surrealdb_root_pw.age".publicKeys = authed;
  "airvpn_config.age".publicKeys = authed;
  "conduit_registration_token.age".publicKeys = authed;
}
