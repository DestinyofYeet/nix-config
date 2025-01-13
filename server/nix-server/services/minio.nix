{
  lib,
  config,
  ...
}:{
  services.minio = {
    # I dunno currently broken? -> yes: https://github.com/NixOS/nixpkgs/pull/288183
    enable = false;

    region = "eu-de-1";

    browser = true;

    dataDir = [
      "/mnt/data/data/minio"
    ];

    consoleAddress = "0.0.0.0:9001";
    listenAddress = "0.0.0.0:9000";
  };

  systemd.tmpfiles.rules = lib.mkIf config.services.minio.enable [
    "A+ /mnt/data/data/minio - - - - user:${config.systemd.services.minio.serviceConfig.User}:rw"
  ];
}
