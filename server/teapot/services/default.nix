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
    ./vpn.nix
    ./home-proxy.nix
    ./postgresql.nix
    ./gitea.nix
    ./nix-search.nix
  ];
}
