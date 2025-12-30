{ keys, ... }@inputs:
let
  user_authed = keys.authed;
  system_authed = [ keys.hosts.wattson.hostKey ] ++ keys.authed;
in {
  "ssh-key-fsim-ori.age".publicKeys = user_authed;
  "ssh-key-oth-gitlab.age".publicKeys = user_authed;
  "ssh-key-vps-main.age".publicKeys = user_authed;
  "ssh-key-github.age".publicKeys = user_authed;
  "ssh-key-nix-server.age".publicKeys = user_authed;
  "ssh-key-fsim-backup.age".publicKeys = user_authed;
  "ssh-key-fsim-pedro.age".publicKeys = user_authed;
  "ssh-key-vps-teapot.age".publicKeys = user_authed;
  "ssh-key-gitea.age".publicKeys = user_authed;
  "ssh-key-nixie.age".publicKeys = user_authed;

  "wireguard-vpn-priv-key.age".publicKeys = system_authed;
}
