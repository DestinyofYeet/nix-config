{
  config,
  ...
}:{
  services.bazarr = {
    enable = true;

    inherit (config.serviceSettings) user group;
  };
}
