let
  ole-main = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKC+o4K+CbcAYSGz+8KWqsm3r878EK2wDSHplFbULwQv ole@main";

  authed = [ ole-main ];

in {
  "ssh-key-github.age".publicKeys = authed;
  "ssh-key-oth-gitlab.age".publicKeys = authed;
  "ssh-key-nix-server.age".publicKeys = authed;
  "ssh-key-vps-main.age".publicKeys = authed;
}
