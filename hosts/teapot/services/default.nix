{ lib, ... }:
{
  imports = [
    ./acme.nix
    ../../parts/ha-haproxy
    ../../parts/idp/cert.nix
    ./sshd.nix
    ./nginx.nix
    ./fail2ban.nix
    # ./netdata.nix
    # ./docker.nix
    # ./ghost.nix
    ./mailserver_simple_nixos.nix
    # ./mailserver_stalwart.nix
    ./matrix.nix
    ./coturn.nix
    # ./hydra.nix
    ./nix-serve.nix
    # ./taskchampion-server.nix
    ./vpn.nix
    # ./home-proxy.nix
    ./postgresql.nix
    ./forgejo.nix
    # ./nix-search.nix
    ./ntfy.nix
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
    ./syncthing.nix
    ./virtualisation.nix
  ];

  services.smartd.enable = lib.mkForce false;
}
