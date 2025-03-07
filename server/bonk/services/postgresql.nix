{ ... }: {
  services.postgresql = {
    enable = true;

    ensureUsers = [{
      name = "nextcloud";
      ensureDBOwnership = true;
    }];

    ensureDatabases = [ "nextcloud" ];
  };
}
