rec {
  wattson = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";
  main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC+o4K+CbcAYSGz+8KWqsm3r878EK2wDSHplFbULwQv ole@main";

  nix-server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAPoi8INcA/HMRtCF9A3sIyfaCIYN0MOTWNg4IEe7zUO root@nixos";
  teapot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOEqmDnGXPNc+Z1DRHVRRqik2WpeGjVoSOdKi1baXafH root@teapot";

  authed = [wattson main];
}
