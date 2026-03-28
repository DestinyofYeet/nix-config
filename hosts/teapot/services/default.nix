{ lib, ... }:
{
  imports = [
    ../../parts/ha-haproxy
    ../../parts/idp/cert.nix
    ./sshd.nix
    ./nginx.nix
    ./fail2ban.nix
    # ./netdata.nix
    # ./docker.nix
    # ./ghost.nix
    ./mailserver.nix
    ./matrix.nix
    ./coturn.nix
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
    ./mealie.nix
    # ./minecraft-server.nix
    ./atuin.nix
    ./strichliste-demo.nix
    # ./github-runner.nix
    ./beszel-agent.nix
    ./mastdodon.nix
    ./livekit.nix
    ../../parts/vaultwarden/config.nix
    ../../parts/idp/config.nix
    (import ../../parts/uptime.nix "uptime.ole.blue")
  ];

  services.smartd.enable = lib.mkForce false;
}
