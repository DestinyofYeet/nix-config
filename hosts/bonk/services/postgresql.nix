{ ... }: {
  services.postgresql = {
    enable = true;

    ensureUsers = [
      {
        name = "nextcloud";
        ensureDBOwnership = true;
      }
      {
        name = "authelia-main";
        ensureDBOwnership = true;
      }
    ];

    ensureDatabases = [ "nextcloud" "authelia-main" ];
  };
}
