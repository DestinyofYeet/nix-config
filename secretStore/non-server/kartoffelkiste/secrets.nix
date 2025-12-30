{ keys, ... }@inputs: {
  "ssh-key-github.age".publicKeys = keys.authed;
  "ssh-key-oth-gitlab.age".publicKeys = keys.authed;
  "ssh-key-gitea.age".publicKeys = keys.authed;
  "ssh-key-nix-server.age".publicKeys = keys.authed;
  "ssh-key-vps-main.age".publicKeys = keys.authed;
  "ssh-key-vps-teapot.age".publicKeys = keys.authed;
  "ssh-key-fsim-pedro.age".publicKeys = keys.authed;
}
