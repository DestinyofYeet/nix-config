{ lib, ... }:{

  options.serviceSettings = with lib; {
    user = mkOption {
      type = types.str;
    };

    group = mkOption {
      type = types.str;
    };
  };

  config.serviceSettings = {
    user = "apps";
    group = "apps";

  };
}
