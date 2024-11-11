let
  ole_laptop =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHeF66q9/UKixJjXGjYXTlwrYcSfMVaYD+W/3pJ+4DP ole@wattson";

  ole-main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC+o4K+CbcAYSGz+8KWqsm3r878EK2wDSHplFbULwQv ole@main";

  authed = [ ole_laptop ole-main ];

in {
  "stalwart-ole-pw.age".publicKeys = authed;
  "nix-config-file.age".publicKeys = authed;

  "ssh-key-github-signing.age".publicKeys = authed;
}
