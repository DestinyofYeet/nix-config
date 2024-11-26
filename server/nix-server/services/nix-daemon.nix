{ ... }: {
  systemd.services.nix-daemon = {
    environment.TMPDIR = "/nix/tmp";
  };

  systemd.tmpfiles.rules = [
    "d /nix/tmp 0755 root root 1d"
  ];
}
