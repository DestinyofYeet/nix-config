{
  pkgs,
  lib,
  ...
}:{
  options.customScripts = with lib; {
    setup-env = mkOption {
      type = types.package;
    };
  };

  config.customScripts = {
    setup-env = pkgs.writers.writeBash "setup-env" ./setup-env.sh;
  };
}
