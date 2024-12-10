let
  nix-server-system =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPoi8INcA/HMRtCF9A3sIyfaCIYN0MOTWNg4IEe7zUO root@nixos";

  nix-server-ole = 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcW4WZw7GhpHkuDBZVY3dpnUfm+8Ww+pyVWAMCB2BuB ole@nix-server";

  ole_laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";

  ole_main = 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC+o4K+CbcAYSGz+8KWqsm3r878EK2wDSHplFbULwQv ole@main";

  teapot-system = 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEqmDnGXPNc+Z1DRHVRRqik2WpeGjVoSOdKi1baXafH root@teapot";

  teapot-ole = 
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO3srCH9OXTJcTRqBPfEkVuVM0zV2mgrzLncHY2rwEUC ole@teapot";
    

  authed = [ nix-server-system nix-server-ole ole_laptop ole_main teapot-system teapot-ole ];

in {
  "cloudflare-api-env.age".publicKeys = authed;
  "nix-serve-priv-key.age".publicKeys = authed;
}
