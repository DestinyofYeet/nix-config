{
  ...
}:
{
  imports = [
    ./sshd.nix
    ./nginx.nix
    ./fail2ban.nix
    ./netdata.nix
    ./virtualisation.nix
    ./ghost.nix
    ./mailserver.nix
    ./conduit.nix
    # ./coturn.nix
    ./hydra.nix
    ./nix-serve.nix
    ./taskchampion-server.nix
  ];
}
