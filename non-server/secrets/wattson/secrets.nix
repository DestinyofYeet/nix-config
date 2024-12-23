let
  ole_laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";

  authed = [ ole_laptop ];

in
{
  "ssh-key-fsim-ori.age".publicKeys = authed;
  "ssh-key-oth-gitlab.age".publicKeys = authed;
  "ssh-key-vps-main.age".publicKeys = authed;
  "ssh-key-github.age".publicKeys = authed;
  "ssh-key-nix-server.age".publicKeys = authed;
  "ssh-key-fsim-backup.age".publicKeys = authed;
  "ssh-key-fsim-pedro.age".publicKeys = authed;
  "ssh-key-vps-teapot.age".publicKeys = authed;
}
