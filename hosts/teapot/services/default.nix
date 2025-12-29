{ lib, ... }: {
  imports = [
    ./sshd.nix
    ./nginx.nix
    # ./fail2ban.nix
    ./netdata.nix
    # ./docker.nix
    # ./ghost.nix
    ./mailserver.nix
    ./conduit.nix
    # ./coturn.nix
    # ./hydra.nix
    ./nix-serve.nix
    # ./taskchampion-server.nix
    ./vpn.nix
    # ./home-proxy.nix
    ./postgresql.nix
    ./forgejo.nix
    ./nix-search.nix
    ./ntfy.nix
    # ./nebula.nix # now in baseline
    ./mealie.nix # currently broken
    ./minecraft-server.nix
    ./atuin.nix
    ./strichliste-demo.nix
    # ./github-runner.nix
    ./beszel-agent.nix
    ./mastdodon.nix
    ./authentik.nix
  ];

  services.smartd.enable = lib.mkForce false;
}
