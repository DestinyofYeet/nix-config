{ ... }: {
  imports = [
    ./settings.nix
    ./nfs.nix
    ./add-replay-gain.nix
    # ./matrix-conduit.nix
    ./qbittorrent.nix
    ./jellyfin.nix
    ./surrealdb.nix
    # ./monero.nix
    ./uptime-kuma.nix
    ./nix-serve.nix
    # ./netdata.nix
    ./navidrome.nix
    ./netdata.nix
    ./openssh.nix
    # ./hydra.nix
    # ./innernet.nix
    ./prowlarr.nix
    ./syncthing.nix
    ./clean-unused-files.nix
    ./nix-daemon.nix
    ./virtualisation.nix
    ./shokoserver.nix
    ./flaresolverr.nix
    ./sonarr.nix
    ./fireflyiii.nix
    ./engelsystem.nix
    ./postgresql.nix
    ./firefly-iii-importer.nix
    # ./passbolt.nix
    ./unbound.nix
    # ./ups.nix
    ./strichliste.nix
    # ./znapzend.nix
    ./bazarr.nix
    ./zfs-mail.nix
    ./wifi.nix
    ./acme.nix
    ./deluge.nix
    ./ankisync.nix
    # ./roundcube.nix
    ./auto-add-torrents.nix
    ./prometheus.nix
    ./grafana.nix
    ./radarr.nix
    ./paperless-ngx.nix
    ./immich.nix
    ./msmtp.nix
    ./wiki-js.nix
    ./vpn.nix
    # ./nextcloud.nix
    # ./minio.nix
    ./garage.nix
    ./nginx.nix
    ./smb.nix
    ./lldap.nix
    ./parsedmarc.nix
    # ./elasticsearch.nix
    ./smartd.nix
    ./backup.nix
    ./kavita.nix
    # ./zabbix.nix
    # ./photoprism.nix
    # ./sunshine.nix
    ./beszel.nix
    ./home-assistant.nix
    # ./authentik.nix
    ./minecraft
    ./jellyseer.nix
  ];
}
