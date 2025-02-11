{
  lib,
  config,
  options,
  custom,
  ...
}: {
  options = custom.nebula.getConfig lib config options;
}
