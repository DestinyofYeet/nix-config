{ ... }: {
  imports = [
    ./nextcloud.nix
    ./postgresql.nix
    ./nginx.nix
    ./openssh.nix
    ./authelia.nix
    ./netdata.nix
  ];
}
