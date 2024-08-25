let
  ole_laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";

  authed = [ ole_laptop ];

in {
  "ssh-key-fsim-ori.age".publicKeys = authed;
  "ssh-key-oth-gitlab.age".publicKeys = authed;
  "ssh-key-vps-main.age".publicKeys = authed;
  "ssh-key-github.age".publicKeys = authed;
}
