{
  config,
  ...
}:
{
  services.postgresql = {
    enable = true;

    ensureUsers = [
      # {
      #   name = config.services.gitea.database.user;
      #   ensureDBOwnership = true;
      # }
    ];

    ensureDatabases = [
      # config.services.gitea.database.name
    ];
  };
}
