{
  config,
  ...
}:
{
  services.postgresql = {
    enable = true;

    ensureUsers = [
      {
        name = config.services.forgejo.database.user;
        ensureDBOwnership = true;
      }
    ];

    ensureDatabases = [
      config.services.forgejo.database.name
    ];
  };
}
