{
  config,
  ...
}:{
  config.systemd.services.conduit.serviceConfig.EnvironmentFile = config.age.secrets.conduit-env-file.path;
}
